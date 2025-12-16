import Foundation

public enum RecipeAppError: Error, LocalizedError {
    case dataLoadingError(underlying: Error)
    case dataSavingError(underlying: Error)
    case unknownError(underlying: Error)
    
    public var errorDescription: String? {
        switch self {
        case .dataSavingError(let error):
            return "Failed to save data: \(error.localizedDescription)"
        case .dataLoadingError(let error):
            return "Failed to load data: \(error.localizedDescription)"
        case .unknownError(let error):
            return "An unknown error occurred: \(error.localizedDescription)"
        }
    }
}
