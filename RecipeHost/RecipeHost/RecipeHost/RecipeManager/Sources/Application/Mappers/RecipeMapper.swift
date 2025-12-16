import Foundation
import Domain

public struct RecipeMapper {
    public static func mapToEntity(from dto: CreateRecipeDTO) throws -> Recipe {
        let recipe = Recipe(
            id: UUID(),
            title: dto.title,
            description: dto.description,
            calories: dto.calories,
            cookingTime: dto.cookingTime,
            servings: Int(dto.servings) ?? 0,
            category: dto.category,
            ingredients: dto.ingredients,
            isFavorite: false,
            createdAt: Date()
        )
        
        try recipe.validate()
        
        return recipe
    }
}
