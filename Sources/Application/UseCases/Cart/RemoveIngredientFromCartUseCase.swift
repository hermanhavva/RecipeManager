import Foundation

public class RemoveFromCartUseCase {
    private let repository: CartRepositoryType
    
    public init(repository: CartRepositoryType) {
        self.repository = repository
    }
    
    public func execute(id: UUID, from cartId: UUID) async throws {

        do {
            return try await repository.remove(id: id, from: cartId)
        } catch {
            throw RecipeAppError.dataLoadingError(underlying: error)
        }
    }
}
