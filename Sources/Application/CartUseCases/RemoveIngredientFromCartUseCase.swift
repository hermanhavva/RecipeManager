import Foundation

public class RemoveFromCartUseCase {
    private let repository: CartRepositoryType
    
    public init(repository: CartRepositoryType) {
        self.repository = repository
    }
    
    public func execute(id: UUID, from cartId: UUID) async throws {
        try await repository.remove(id: id, from: cartId)
    }
}
