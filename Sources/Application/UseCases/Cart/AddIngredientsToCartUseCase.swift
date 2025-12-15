import Foundation
import Domain

public class AddIngredientsToCartUseCase {
    private let repository: CartRepositoryType
    
    public init(repository: CartRepositoryType) {
        self.repository = repository
    }
    
    public func execute(ingredientDto: CreateIngredientDTO, to cartId: UUID) async throws {

        do {
            let ingredientsToAdd = try [IngredientMapper.mapToEntity(from: ingredientDto)]
            try await repository.add(ingredients: ingredientsToAdd, to: cartId)
        }
        catch let domainError as DomainError {
            throw domainError
        }
        catch {
            throw RecipeAppError.unknownError(underlying: error)
        }
    }
}
