import Foundation
import Domain

public protocol CartRepositoryType {
    func getItems(cartId: UUID) async throws -> [Ingredient]
    func add(ingredients: [Ingredient], to cartId: UUID) async throws
    func add(ingredient: Ingredient, to cartId: UUID) async throws
    func remove(id: UUID, from cartId: UUID) async throws
    func clear(cartId: UUID) async throws
}

