import Foundation

public enum RecipeAppError: Error, LocalizedError {
//    case dataLoadingError(underlying: DomainError)
//    case domainError(underlying: DomainError)
    case unknownError(underlying: Error)
    
    public var errorDescription: String? {
        switch self {
        case .unknownError(let error):
            return "An unknown error occurred: \(error.localizedDescription)"
        }
    }
}
