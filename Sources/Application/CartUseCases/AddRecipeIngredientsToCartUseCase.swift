import Foundation
import Domain

public class AddRecipeIngredientsToCartUseCase {
    private let repository: CartRepositoryType
    public init(repository: CartRepositoryType) {
        self.repository = repository
    }
    
    public func execute(recipe: Recipe, to cartId: UUID) async throws {
        let ingredientsForCart = recipe.ingredients.map { original in
            Ingredient(
                id: UUID(),
                name: original.name,
                amount: original.amount,
                unit: original.unit
            )
        }
        try await repository.add(ingredients: ingredientsForCart, to: cartId)
    }
}
