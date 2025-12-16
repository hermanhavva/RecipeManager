import Foundation

public final class CartConflictError: DomainError {
    public init(cartId: UUID) {
        super.init(reason: "A cart with the id '\(cartId)' already exists.")
    }
    
    public required override init(reason: String) {
        super.init(reason: reason)
    }
}
