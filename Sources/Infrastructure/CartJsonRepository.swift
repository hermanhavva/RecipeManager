import Foundation
import Domain
import Application

public class CartJsonRepository: CartRepositoryType {
    private let storage: JSONRepository<Cart>
    
    public init(fileName: String = "carts") {
        self.storage = JSONRepository<Cart>(fileName: fileName)
    }
      
    private func getCart(id: UUID) async throws -> Cart {
        guard let cart = try await storage.getById(id: id) else {
            throw CartNotFoundError(reason: "Cart with id \(id) was not found.")
        }
        return cart
    }
    
    // MARK: - Public Interface
    
    public func getItems(cartId: UUID) async throws -> [Ingredient] {
        let cart = try await getCart(id: cartId)
        return cart.ingredients
    }
    
    public func create(cart: Cart) async throws {
        if let _ = try await storage.getById(id: cart.id) {
            throw CartConflictError(cartId: cart.id)
        }
        
        try await storage.add(cart)
    }
    
    public func add(ingredients newIngredients: [Ingredient], to cartId: UUID) async throws {
        var cart = try await getCart(id: cartId)
        
        var currentIngredients = cart.ingredients
        
        for incomingItem in newIngredients {
            if let index = currentIngredients.firstIndex(where: { $0.canMerge(with: incomingItem) }) {
                // MERGE: Found an existing match
                let existingItem = currentIngredients[index]
                let mergedItem = existingItem.merging(with: incomingItem)
                
                currentIngredients[index] = mergedItem
            } else {
                // No match found
                currentIngredients.append(incomingItem)
            }
        }
        
        cart.ingredients = currentIngredients
        try await storage.update(cart)
    }
    
    public func add(ingredient: Ingredient, to cartId: UUID) async throws {
        try await add(ingredients: [ingredient], to: cartId)
    }
    
    public func remove(id: UUID, from cartId: UUID) async throws {
        var cart = try await getCart(id: cartId)
        
        guard cart.ingredients.contains(where: { $0.id == id }) else {
            throw IngredientNotFoundError(reason: "Ingredient with id \(id) not found in cart.")
        }
        
        cart.ingredients.removeAll(where: { $0.id == id })
        try await storage.update(cart)
    }
    
    public func clear(cartId: UUID) async throws {
        var cart = try await getCart(id: cartId)
        
        cart.ingredients.removeAll()
        try await storage.update(cart)
    }
}
