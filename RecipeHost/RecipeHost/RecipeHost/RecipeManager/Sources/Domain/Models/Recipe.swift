import Foundation


public enum RecipeCategory: String, Codable, CaseIterable {
    case breakfast = "Breakfast"
    case lunch = "Lunch"
    case dinner = "Dinner"
    case snack = "Snack"
}


public struct Recipe: Identifiable, Codable, Equatable {
    public let id: UUID
    public let title: String
    public let description: String
    public let calories: Int
    public let cookingTime: TimeInterval
    public let servings: Int
    public let category: RecipeCategory
    public let ingredients: [Ingredient]
    public var isFavorite: Bool
    public let createdAt: Date
    
    public init(id: UUID = UUID(),
                title: String,
                description: String,
                calories: Int,
                cookingTime: TimeInterval,
                servings: Int,
                category: RecipeCategory,
                ingredients: [Ingredient],
                isFavorite: Bool = false,
                createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.description = description
        self.calories = calories
        self.cookingTime = cookingTime
        self.servings = servings
        self.category = category
        self.ingredients = ingredients
        self.isFavorite = isFavorite
        self.createdAt = createdAt
    }
    public func validate() throws {
            
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw RecipeConstraintValidationError(reason: "The tile cannot be empty")
        }
            
        guard calories > 0 else {
            throw RecipeConstraintValidationError(reason: "The calories must be greater than 0")
        }
            
        guard cookingTime > 0 else {
            throw RecipeConstraintValidationError(reason: "The cooking time cannot be negative")
        }
            
        guard servings > 0 else {
            throw RecipeConstraintValidationError(reason: "The servings amount cannot be negative")
        }
            
        guard !ingredients.isEmpty else {
            throw RecipeConstraintValidationError(reason: "The ingredients list cannot be empty")
        }
    }
}
