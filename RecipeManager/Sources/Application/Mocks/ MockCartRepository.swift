import Foundation
@testable import Domain
//@testable import Application

public class MockCartRepository: CartRepositoryType {
    
    var carts: [UUID: [Ingredient]] = [:]
    func getItemsInMock(cartId: UUID) -> [Ingredient] {
        return carts[cartId] ?? []
    }
    
    public init(carts: [UUID : [Ingredient]] = [:]) {
        self.carts = carts
    }
    
    public func create(cart: Cart) async throws {
        if (carts.keys.contains(cart.id)){
            throw CartConflictError(cartId: cart.id)
        }
        
        carts[cart.id] = cart.ingredients
    }
    
    public func getItems(cartId: UUID) async throws -> [Ingredient] {
        return carts[cartId] ?? []
    }
    
    public func add(ingredients: [Ingredient], to cartId: UUID) async throws {
        var currentItems = carts[cartId] ?? []
        currentItems.append(contentsOf: ingredients)
        carts[cartId] = currentItems
    }
    
    public func add(ingredient: Ingredient, to cartId: UUID) async throws {
        var currentItems = carts[cartId] ?? []
        currentItems.append(ingredient)
        carts[cartId] = currentItems
    }
    
    public func remove(id: UUID, from cartId: UUID) async throws {
        var currentItems = carts[cartId] ?? []
        currentItems.removeAll { $0.id == id }
        carts[cartId] = currentItems
    }
    
    public func clear(cartId: UUID) async throws {
        carts[cartId] = []
    }
}
