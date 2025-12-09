import Foundation
import Domain

public protocol RecipeRepositoryType {
    func fetchRecipes() async throws -> [Recipe]
    func save(recipe: Recipe) async throws
    func update(recipe: Recipe) async throws
    func delete(recipeId: UUID) async throws
}
