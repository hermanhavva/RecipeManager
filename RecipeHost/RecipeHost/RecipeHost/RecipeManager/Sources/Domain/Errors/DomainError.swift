import Foundation

open class DomainError: Error, LocalizedError {
    public let reason: String
    
    public init(reason: String) {
        self.reason = reason
    }
    
    public var errorDescription: String? {
        return reason
    }
}
