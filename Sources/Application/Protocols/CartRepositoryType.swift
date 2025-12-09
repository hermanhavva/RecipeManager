import Foundation
import Domain

public protocol CartRepositoryType {
    func getItems() async throws -> [Ingredient]
    func add(ingredients: [Ingredient]) async throws
    func add(ingredient: Ingredient) async throws
    func remove(id: UUID) async throws
    func clear() async throws
}
