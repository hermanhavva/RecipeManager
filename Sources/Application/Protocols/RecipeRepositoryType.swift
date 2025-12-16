import Foundation
import Domain

public protocol RecipeRepositoryType {
    func GetAll() async throws -> [Recipe]
    func getById(id: UUID) async throws -> Recipe?
    func create(recipe: Recipe) async throws
    func update(recipe: Recipe) async throws
    func delete(recipeId: UUID) async throws
}
