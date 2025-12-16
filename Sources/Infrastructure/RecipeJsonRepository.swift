import Foundation
import Application
import Domain

public class RecipeJsonRepository: RecipeRepositoryType {
    private let storage: JSONRepository<Recipe>
    
    public init() {
        self.storage = JSONRepository<Recipe>(fileName: "recipes")
    }
    
    public func GetAll() async throws -> [Recipe] {
        return try await storage.fetchAll()
    }
    
    public func getById(id: UUID) async throws -> Recipe? {
        return try await storage.getById(id: id)
    }
    
    public func create(recipe: Recipe) async throws {
        let allRecipes = try await storage.fetchAll()
        
        if allRecipes.contains(where: { $0.title.lowercased() == recipe.title.lowercased() }) {
            throw RecipeConflictError(recipeTitle: recipe.title)
        }
        
        try await storage.add(recipe)
    }
    
    public func update(recipe: Recipe) async throws {
        guard (try await storage.getById(id: recipe.id)) != nil else {
            throw RecipeNotFoundError(reason: "The recipe with id \(recipe.id) does not exist.")
        }
        
        try await storage.update(recipe)
    }
    
    public func delete(recipeId: UUID) async throws {
        guard (try await storage.getById(id: recipeId)) != nil else {
            throw RecipeNotFoundError(reason: "The recipe with id \(recipeId) does not exist.")
        }
        try await storage.delete(id: recipeId)
    }
}
