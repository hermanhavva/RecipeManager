import Foundation
import Domain

public struct RecipeMapper {
    
    public static func map(dto: CreateRecipeDTO) throws -> Recipe {
        guard !dto.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw RecipeAppError.invalidTitle
        }
        
        guard let calInt = Int(dto.calories), calInt > 0 else {
            throw RecipeAppError.invalidCalories
        }
        
        guard let timeInt = Int(dto.cookingTime), timeInt > 0 else {
            throw RecipeAppError.invalidCookingTime
        }
        
        guard let servInt = Int(dto.servings), servInt > 0 else {
            throw RecipeAppError.invalidServings
        }
        
        guard !dto.ingredients.isEmpty else {
            throw RecipeAppError.emptyIngredients
        }
        
        guard !dto.description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw RecipeAppError.emptyInstructions
        }
        
        return Recipe(
            id: UUID(),
            title: dto.title,
            description: dto.description,
            calories: calInt,
            cookingTime: timeInt,
            servings: servInt,
            category: dto.category,
            ingredients: dto.ingredients,
            isFavorite: false,
            createdAt: Date()
        )
    }
}
