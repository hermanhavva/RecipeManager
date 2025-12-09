import Foundation
import Domain

public class GetCartItemsUseCase {
    private let repository: CartRepositoryType
    
    public init(repository: CartRepositoryType) {
        self.repository = repository
    }
    public func execute() async throws -> [Ingredient] {
        return try await repository.getItems()
    }
}
