import Foundation
@testable import Domain
@testable import Application

class MockCartRepository: CartRepositoryType {
    var items: [Ingredient] = []
    
    func getItems() async throws -> [Ingredient] {
        return items
    }
    
    func add(ingredients: [Ingredient]) async throws {
        items.append(contentsOf: ingredients)
    }
    
    func add(ingredient: Ingredient) async throws {
        items.append(ingredient)
    }
    
    func remove(id: UUID) async throws {
        items.removeAll { $0.id == id }
    }
    
    func clear() async throws {
        items.removeAll()
    }
}
