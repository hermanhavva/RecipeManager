import Foundation
@testable import Domain
@testable import Application

class MockRecipeRepository: RecipeRepositoryType {
    var items: [Recipe] = []
    
    func fetchRecipes() async throws -> [Recipe] {
        return items
    }
    
    func save(recipe: Recipe) async throws {
        items.append(recipe)
    }
    func update(recipe: Recipe) async throws {
        if let index = items.firstIndex(where: { $0.id == recipe.id }) {
            items[index] = recipe
        }
    }
    func delete(recipeId: UUID) async throws {
        items.removeAll { $0.id == recipeId }
    }
}
