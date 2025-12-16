import Foundation
import Combine
import Domain
import Application

public class RecipeAddViewModel {
    
    // MARK: - Dependencies
    private let createRecipeUseCase: CreateRecipeUseCase
    
    // MARK: - Output States (Observables)
    // We use @Published so the VC can subscribe to changes
    @Published public var isLoading: Bool = false
    @Published public var errorMessage: String? = nil
    @Published public var isSuccess: Bool = false
    
    // MARK: - Init
    public init(createRecipeUseCase: CreateRecipeUseCase) {
        self.createRecipeUseCase = createRecipeUseCase
    }
    
    // MARK: - Intents
    public func createRecipe(
        title: String?,
        calories: String?,
        time: String?,
        servings: String?,
        description: String?,
        ingredientsData: [(name: String?, amount: String?, unit: String?)]
    ) {
        // 1. Reset State
        self.errorMessage = nil
        self.isSuccess = false
        self.isLoading = true
        
        Task { @MainActor in
            defer {
                self.isLoading = false
            }
            
            // 2. Input Validation & Conversion
            guard let title = title, !title.isEmpty else {
                self.errorMessage = "Будь ласка, введіть назву рецепту."
                return
            }
            
            // Convert Strings to Numbers safely
            // defaults to 0 if invalid, validation logic in Domain will catch specific issues if needed
            let caloriesInt = Int(calories ?? "") ?? 0
            let timeInterval = TimeInterval(time ?? "") ?? 0
            let servingsStr = servings ?? "1" // DTO expects String for servings
            
            // 3. Map Ingredients
            let mappedIngredients: [CreateIngredientDTO] = ingredientsData.compactMap { (name, amount, unit) -> CreateIngredientDTO? in
                guard let name = name, !name.isEmpty, let amount, let unit else {
                    return nil
                }
                
                // Ensure you match the actual init of your Ingredient struct here
                // based on previous context, likely similar to:
                return CreateIngredientDTO(name: name, amount: Int(amount) ?? 0, unit: unit)
            }
            
            if mappedIngredients.isEmpty {
                self.errorMessage = "Додайте хоча б один інгредієнт."
                return
            }
            
            // 4. Create DTO
            // Note: UI currently lacks a Category picker, defaulting to .lunch or passing a param
            let dto = CreateRecipeDTO(
                title: title,
                description: description ?? "",
                calories: caloriesInt,
                cookingTime: timeInterval,
                servings: servingsStr,
                category: .lunch, // TODO: Add a Picker in UI to select this
                ingredients: mappedIngredients
            )
            
            // 5. Execute Use Case
            do {
                try await createRecipeUseCase.execute(dto: dto)
                self.isSuccess = true
            } catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
