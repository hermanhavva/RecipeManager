import Foundation
import Domain

public protocol RecipeRepositoryType {
    func get() async throws -> [Recipe]
    func getById(id: UUID) async throws -> Recipe?
    func add(recipe: Recipe) async throws
    func update(recipe: Recipe) async throws
    func delete(recipeId: UUID) async throws
}
