import Foundation

public enum RecipeAppError: Error, LocalizedError {
    case dataLoadingError(underlying: Error)
    case unknownError
    
    public var errorDescription: String? {
        switch self {
        case .dataLoadingError(let error):
            return "Failed to save or load data: \(error.localizedDescription)"
        case .unknownError:
            return "An unknown error occurred."
        }
    }
}
