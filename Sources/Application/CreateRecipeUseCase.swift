import Foundation
import Domain

public class CreateRecipeUseCase {
    private let repository: RecipeRepositoryType
    
    public init(repository: RecipeRepositoryType) {
        self.repository = repository
    }
    
    public func execute(title: String, description: String, calories: Int, cookingTime: Int, servings: Int, category: RecipeCategory, ingredients: [Ingredient]) async throws {
        guard !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw NSError(domain: "RecipeLogic", code: 1, userInfo: [NSLocalizedDescriptionKey: "Recipe name is required"])
        }
        guard !ingredients.isEmpty else {
            throw NSError(domain: "RecipeLogic", code: 2, userInfo: [NSLocalizedDescriptionKey: "Add at least one ingredient"])
        }
        guard !description.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            throw NSError(domain: "RecipeLogic", code: 3, userInfo: [NSLocalizedDescriptionKey: "Recipe steps description is required"])
        }
        guard calories > 0 else {
            throw NSError(domain: "RecipeLogic", code: 4, userInfo: [NSLocalizedDescriptionKey: "Calories must be greater than 0"])
        }
            
        guard cookingTime > 0 else {
            throw NSError(domain: "RecipeLogic", code: 5, userInfo: [NSLocalizedDescriptionKey: "Cooking time must be greater than 0"])
        }
            
        guard servings > 0 else {
            throw NSError(domain: "RecipeLogic", code: 6, userInfo: [NSLocalizedDescriptionKey: "Servings must be greater than 0"])
        }
        
        let newRecipe = Recipe(
            title: title,
            description: description,
            calories: calories,
            cookingTime: cookingTime,
            servings: servings,
            category: category,
            ingredients: ingredients
        )
        
        try await repository.save(recipe: newRecipe)
    }
}
