import Foundation
import Domain

public class GetCartItemsUseCase {
    private let repository: CartRepositoryType
    
    public init(repository: CartRepositoryType) {
        self.repository = repository
    }
    
    public func execute(cartId: UUID) async throws -> [Ingredient] {
        do {
            return try await repository.getItems(cartId: cartId)
        }
        catch let domainError as DomainError {
            throw domainError
        }
        catch {
            throw RecipeAppError.unknownError(underlying: error)
        }
    }
}

