import Foundation
import Domain

public class AddIngredientsToCartUseCase {
    private let repository: CartRepositoryType
    
    public init(repository: CartRepositoryType) {
        self.repository = repository
    }
    
    public func execute(ingredientDto: CreateIngredientDTO, to cartId: UUID) async throws {
        let ingredientsToAdd = [IngredientMapper.mapToEntity(from: ingredientDto)]
        
        do {
            try await repository.add(ingredients: ingredientsToAdd, to: cartId)
        } catch {
            throw RecipeAppError.dataLoadingError(underlying: error)
        }
    }
}
