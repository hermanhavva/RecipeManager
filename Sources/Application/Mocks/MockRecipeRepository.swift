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
        if !recipeIsPresent(recipeId: id){
            throw RecipeNotFoundError(reason: "Recipe with id: \(id) not found")
        }
        
        return items.first(where: { $0.id == id })
    }
    
    public func getFavorites() async throws -> [Recipe] {
        return items.filter { $0.isFavorite }
    }
    
    public func create(recipe: Recipe) async throws {
        items.append(recipe)
    }
    
    public func update(recipe: Recipe) async throws {
        if !recipeIsPresent(recipeId: recipe.id) {
            throw RecipeNotFoundError(reason: "Recipe with id: \(recipe.id) not found")
        }
        
        if let index = items.firstIndex(where: { $0.id == recipe.id }) {
            items[index] = recipe
        }
    }
    
    public func delete(recipeId: UUID) async throws {
        
        if !recipeIsPresent(recipeId: recipeId) {
            throw RecipeNotFoundError(reason: "Recipe with id: \(recipeId) not found")
        }
        
        items.removeAll { $0.id == recipeId }
    }
    
    private func recipeIsPresent(recipeId: UUID) -> Bool {
        return items.contains(where: {
            $0.id == recipeId
        })
    }
}
