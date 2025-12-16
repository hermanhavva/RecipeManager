import Foundation
import Domain
import Application

public class CartJsonRepository: CartRepositoryType {
    private let storage: JSONRepository<Cart>
    
    public init() {
        self.storage = JSONRepository<Cart>(fileName: "carts")
    }
    
    // Helper: Ensure the cart exists, or create a default one
    private func getOrCreateCart(id: UUID) async throws -> Cart {
        if let existing = try await storage.getById(id: id) {
            return existing
        } else {
            let newCart = Cart(id: id)
            try await storage.add(newCart)
            return newCart
        }
    }
    
    public func getItems(cartId: UUID) async throws -> [Ingredient] {
        let cart = try await getOrCreateCart(id: cartId)
        return cart.ingredients
    }
    
    public func create(cart: Cart) async throws {
        // Check if already exists?
        if let _ = try await storage.getById(id: cart.id) {
            // Maybe throw conflict or just ignore? Assuming silent success for now.
            return
        }
        try await storage.add(cart)
    }
    
    public func add(ingredients: [Ingredient], to cartId: UUID) async throws {
        var cart = try await getOrCreateCart(id: cartId)
        cart.ingredients.append(contentsOf: ingredients)
        try await storage.update(cart)
    }
    
    public func add(ingredient: Ingredient, to cartId: UUID) async throws {
        try await add(ingredients: [ingredient], to: cartId)
    }
    
    public func remove(id: UUID, from cartId: UUID) async throws {
        var cart = try await getOrCreateCart(id: cartId)
        
        // Check if ingredient exists in cart
        guard cart.ingredients.contains(where: { $0.id == id }) else {
            // Throwing a Domain Error here would be appropriate if strict
            // For now, let's assume if it's not there, our job is done, or throw generic
            throw NSError(domain: "CartRepo", code: 404, userInfo: [NSLocalizedDescriptionKey: "Ingredient not found in cart"])
        }
        
        cart.ingredients.removeAll(where: { $0.id == id })
        try await storage.update(cart)
    }
    
    public func clear(cartId: UUID) async throws {
        var cart = try await getOrCreateCart(id: cartId)
        cart.ingredients.removeAll()
        try await storage.update(cart)
    }
}
