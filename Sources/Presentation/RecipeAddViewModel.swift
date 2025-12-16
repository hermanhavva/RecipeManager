import Foundation
import Combine
import Domain
import Application

public class RecipeAddViewModel {
    
    // MARK: - Dependencies
    private let createRecipeUseCase: CreateRecipeUseCase
    
    // MARK: - Output States (Observables)
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
        // reset state
        self.errorMessage = nil
        self.isSuccess = false
        self.isLoading = true
        
        Task { @MainActor in
            defer {
                self.isLoading = false
            }
            
            // input validation
            guard let title = title, !title.isEmpty else {
                self.errorMessage = "Будь ласка, введіть назву рецепту."
                return
            }
            
            let caloriesInt = Int(calories ?? "") ?? 0
            let timeInterval = TimeInterval(time ?? "") ?? 0
            let servingsStr = servings ?? "1"
            
            let mappedIngredients: [CreateIngredientDTO] = ingredientsData.compactMap { (name, amount, unit) -> CreateIngredientDTO? in
                guard let name = name, !name.isEmpty, let amount, let unit else {
                    return nil
                }
                
                return CreateIngredientDTO(name: name, amount: Int(amount) ?? 0, unit: unit)
            }
            
            if mappedIngredients.isEmpty {
                self.errorMessage = "Додайте хоча б один інгредієнт."
                return
            }
            
            // create DTO
            let dto = CreateRecipeDTO(
                title: title,
                description: description ?? "",
                calories: caloriesInt,
                cookingTime: timeInterval,
                servings: servingsStr,
                category: .lunch, // TODO: Add a Picker in UI to select this
                ingredients: mappedIngredients
            )
            
            
            do {
                try await createRecipeUseCase.execute(dto: dto)
                self.isSuccess = true
            }
            catch {
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
