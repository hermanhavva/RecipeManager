import Foundation
import Domain

public class RemoveFromCartUseCase {
    private let repository: CartRepositoryType
    
    public init(repository: CartRepositoryType) {
        self.repository = repository
    }
    
    public func execute(id: UUID, from cartId: UUID) async throws {
        do {
            try await repository.remove(id: id, from: cartId)
        }
        catch let domainError as DomainError {
            throw domainError
        }
        catch let error as RecipeAppError {
            throw error
        }
        catch {
            throw RecipeAppError.unknownError(underlying: error)
        }
    }
}
