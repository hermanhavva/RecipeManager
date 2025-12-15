
import Foundation
import Domain

public class AddRecipeIngredientsToCartUseCase {
    private let cartRepository: CartRepositoryType
    private let recipeRepository: RecipeRepositoryType
    
    public init(cartRepository: CartRepositoryType, recipeRepository: RecipeRepositoryType) {
        self.cartRepository = cartRepository
        self.recipeRepository = recipeRepository
    }
    
    public func execute(recipeId: UUID, to cartId: UUID) async throws {
        do {
            guard let recipe = try await recipeRepository.getById(id: recipeId) else {
                throw RecipeNotFoundError(reason: "The recipe with id \(recipeId) does not exist")
            }
            
            let ingredientsToAdd = recipe.ingredients.map { original in
                Ingredient(
                    id: UUID(),
                    name: original.name,
                    amount: original.amount,
                    unit: original.unit
                )
            }
            
            try await cartRepository.add(ingredients: ingredientsToAdd, to: cartId)
            
        }
        catch let domainError as DomainError {
            throw domainError
            
        }
        catch {
            throw RecipeAppError.unknownError(underlying: error)
        }
    }
}
