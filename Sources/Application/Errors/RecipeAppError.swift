import Foundation

public enum RecipeAppError: Error, LocalizedError {
    case invalidTitle
    case invalidCalories
    case invalidCookingTime
    case invalidServings
    case emptyIngredients
    case emptyInstructions
    case recipeNotFound
    case dataLoadingError

    public var errorDescription: String? {
        switch self {
            case .invalidTitle: return "Recipe title is required."
            case .invalidCalories: return "Calories must be greater than 0."
            case .invalidCookingTime: return "Cooking time must be valid."
            case .invalidServings: return "Servings must be greater than 0."
            case .emptyIngredients: return "Add at least one ingredient."
            case .emptyInstructions: return "Instructions cannot be empty."
            case .recipeNotFound: return "Recipe not found."
            case .dataLoadingError: return "Error loading data."
        }
    }
}
