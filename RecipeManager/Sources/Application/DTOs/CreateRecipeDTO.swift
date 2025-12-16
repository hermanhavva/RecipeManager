import Foundation
import Domain

public struct CreateRecipeDTO {
    public let title: String
    public let description: String
    public let calories: Int
    public let cookingTime: TimeInterval
    public let servings: String
    public let category: RecipeCategory
    public let ingredients: [Ingredient]
    
    public init(title: String, description: String, calories: Int, cookingTime: TimeInterval, servings: String, category: RecipeCategory, ingredients: [Ingredient]) {
        self.title = title
        self.description = description
        self.calories = calories
        self.cookingTime = cookingTime
        self.servings = servings
        self.category = category
        self.ingredients = ingredients
    }
}
