import Foundation
import Domain

public struct RecipeMapper {
    public static func map(dto: CreateRecipeDTO) -> Recipe {
        let timeInMinutes = Int(dto.cookingTime / 60)
        
        return Recipe(
            id: UUID(),
            title: dto.title,
            description: dto.description,
            calories: Int(dto.calories) ?? 0,
            cookingTime: timeInMinutes,
            servings: Int(dto.servings) ?? 0,
            category: dto.category,
            ingredients: dto.ingredients,
            isFavorite: false,
            createdAt: Date()
        )
    }
}
