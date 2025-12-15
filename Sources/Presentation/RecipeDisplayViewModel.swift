import Foundation
import Domain
import Application

@MainActor

public class RecipeDisplayViewModel: ObservableObject {
    @Published public var recipe: Recipe
    @Published public var errorMessage: String?
    @Published public var isIngredientsAdded: Bool = false
    
    private let addRecipeToCartUseCase: AddRecipeIngredientsToCartUseCase
    private let defaultCartId = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!// for now we just use default cart
    public init(recipe: Recipe, addRecipeToCartUseCase: AddRecipeIngredientsToCartUseCase) {
        self.recipe = recipe
        self.addRecipeToCartUseCase = addRecipeToCartUseCase
    }
    public func addIngredientsToCart(){
        Task{
            do{
                try await addRecipeToCartUseCase.execute(recipe: recipe, to: defaultCartId)
                self.isIngredientsAdded = true
                try? await Task.sleep(nanoseconds: 1_000_000_000)
                self.isIngredientsAdded = false
            }catch let error as LocalizedError {
                self.errorMessage = error.errorDescription
            }catch{
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
