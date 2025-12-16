import Foundation
import Domain

public struct RecipeMapper {
    public static func mapToEntity(from dto: CreateRecipeDTO) throws -> Recipe {
        var mappedIngredients: [Ingredient] = []
        for dto in dto.ingredients {
            let mappedIngredient = try IngredientMapper.mapToEntity(from: dto)
            mappedIngredients.append(mappedIngredient)
        }
        
        let recipe = Recipe(
            id: UUID(),
            title: dto.title,
            description: dto.description,
            calories: dto.calories,
            cookingTime: dto.cookingTime,
            servings: Int(dto.servings) ?? 0,
            category: dto.category,
            ingredients: mappedIngredients,
            isFavorite: false,
            createdAt: Date()
        )
        
        try recipe.validate()
        
        return recipe
    }
}
