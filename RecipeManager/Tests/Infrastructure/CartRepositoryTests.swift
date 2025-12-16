import XCTest
import Domain
import Application
import Infrastructure

final class CartRepositoryTests: XCTestCase {
    
    var repository: CartJsonRepository!
    var uniqueFileName: String!
    
    override func setUp() async throws {
        
        uniqueFileName = "test_cart_merge_\(UUID().uuidString)"
        repository = CartJsonRepository(fileName: uniqueFileName)
    }
    
    override func tearDown() async throws {
        
        let fileManager = FileManager.default
        let documents = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileURL = documents.appendingPathComponent("\(uniqueFileName!).json")
        
        if fileManager.fileExists(atPath: fileURL.path) {
            try fileManager.removeItem(at: fileURL)
        }
    }
    
    // MARK: - Tests
    
    func test_CreateCart_Success() async throws {
        let cartId = UUID()
        let cart = Cart(id: cartId)
        
        try await repository.create(cart: cart)
        
        let items = try await repository.getItems(cartId: cartId)
        XCTAssertTrue(items.isEmpty)
    }
    
    func test_GetItems_CartDoesNotExist_ThrowsError() async throws {
        let randomId = UUID()
        
        do {
            _ = try await repository.getItems(cartId: randomId)
            XCTFail("Should throw CartNotFoundError if cart doesn't exist")
        } catch is CartNotFoundError {
            // Success
        } catch {
            XCTFail("Wrong error: \(error)")
        }
    }
    
    func test_AddIngredients_UpdatesCart() async throws {
        // 1. Create Cart
        let cartId = UUID()
        let cart = Cart(id: cartId)
        try await repository.create(cart: cart)
        
        // 2. Add Ingredient
        let ingredient = Ingredient(name: "Milk", amount: 1, unit: "L")
        try await repository.add(ingredient: ingredient, to: cartId)
        
        // 3. Verify
        let items = try await repository.getItems(cartId: cartId)
        XCTAssertEqual(items.count, 1)
        XCTAssertEqual(items.first?.name, "Milk")
    }
    
    func test_ClearCart_RemovesAllIngredients() async throws {
        let cartId = UUID()
        let cart = Cart(id: cartId)
        try await repository.create(cart: cart)
        
        let ingredient1 = Ingredient(name: "Eggs", amount: 2, unit: "pcs")
        let ingredient2 = Ingredient(name: "Flour", amount: 500, unit: "g")
        
        try await repository.add(ingredients: [ingredient1, ingredient2], to: cartId)
        
        // Check add worked
        var items = try await repository.getItems(cartId: cartId)
        XCTAssertEqual(items.count, 2)
        
        // Clear
        try await repository.clear(cartId: cartId)
        
        // Verify Empty
        items = try await repository.getItems(cartId: cartId)
        XCTAssertTrue(items.isEmpty)
    }
    
    func test_AddIngredient_ExistingItem_MergesAmountsAndPreservesId() async throws {
        let cartId = UUID()
        try await repository.create(cart: Cart(id: cartId))
        
        let originalMilk = Ingredient(name: "Milk", amount: 1, unit: "L")
        try await repository.add(ingredient: originalMilk, to: cartId)
        
        let newMilk = Ingredient(name: "milk", amount: 2, unit: "l")
        try await repository.add(ingredient: newMilk, to: cartId)
        
        let items = try await repository.getItems(cartId: cartId)
        
        XCTAssertEqual(items.count, 1, "Should have merged into 1 item, not 2")
        
        let savedItem = items.first!
        XCTAssertEqual(savedItem.amount, 3, "1L + 2L should equal 3L")
        XCTAssertEqual(savedItem.id, originalMilk.id, "Should preserve the original ID (important for UI consistency)")
        XCTAssertEqual(savedItem.name, "Milk", "Should preserve the original name casing")
    }
    
    func test_AddIngredients_MixedBatch_MergesAndAppendsCorrectly() async throws {
        let cartId = UUID()
        try await repository.create(cart: Cart(id: cartId))
        
        let existingFlour = Ingredient(name: "Flour", amount: 500, unit: "g")
        try await repository.add(ingredient: existingFlour, to: cartId)
        
        let batch = [
            Ingredient(name: "flour", amount: 200, unit: "g"),
            Ingredient(name: "Sugar", amount: 100, unit: "g"),
            Ingredient(name: "sugar", amount: 50, unit: "g")
        ]
        
        try await repository.add(ingredients: batch, to: cartId)
        
        let items = try await repository.getItems(cartId: cartId)
        XCTAssertEqual(items.count, 2, "Cart should end up with exactly 2 items: Flour and Sugar")
        
        // check Flour
        let savedFlour = items.first(where: { $0.name.lowercased() == "flour" })
        XCTAssertNotNil(savedFlour)
        XCTAssertEqual(savedFlour?.amount, 700, "500g + 200g should be 700g")
        
        // check Sugar
        let savedSugar = items.first(where: { $0.name.lowercased() == "sugar" })
        XCTAssertNotNil(savedSugar)
        XCTAssertEqual(savedSugar?.amount, 150, "100g + 50g should be 150g")
    }
}
