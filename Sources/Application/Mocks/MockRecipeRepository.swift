import Foundation
@testable import Domain
//@testable import Application

public class MockRecipeRepository: RecipeRepositoryType {
    var items: [Recipe] = []
    
    public init(recipes: [Recipe] = []) {
        self.items = recipes
    }
    
    public func getAll() async throws -> [Recipe] {
        return items
    }
    
    public func getById(id: UUID) async throws -> Recipe? {
        return items.first(where: { $0.id == id })
    }
    
    public func getFavorites() async throws -> [Recipe] {
        return items.filter { $0.isFavorite }
    }
    
    public func create(recipe: Recipe) async throws {
        items.append(recipe)
    }
    public func update(recipe: Recipe) async throws {
        if let index = items.firstIndex(where: { $0.id == recipe.id }) {
            items[index] = recipe
        }
    }
    public func delete(recipeId: UUID) async throws {
        items.removeAll { $0.id == recipeId }
    }
}
