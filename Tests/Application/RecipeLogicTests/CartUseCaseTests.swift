import XCTest
@testable import Domain
@testable import Application

final class CartUseCaseTests: XCTestCase {
    
    var mockCartRepo: MockCartRepository!
    var mockRecipeRepo: MockRecipeRepository!
    let testCartId = UUID()
    
    override func setUp() {
        super.setUp()
        mockCartRepo = MockCartRepository()
        mockRecipeRepo = MockRecipeRepository()
    }
    
    func test_addRecipeToCart_addsAllIngredients() async throws {
        let useCase = AddRecipeIngredientsToCartUseCase(cartRepository: mockCartRepo, recipeRepository: mockRecipeRepo)
        
        let ing1 = Ingredient(name: "Milk", amount: 1, unit: "l")
        let ing2 = Ingredient(name: "Eggs", amount: 2, unit: "pc")
        
        let recipe = Recipe(
            title: "Pancakes",
            description: "",
            calories: 100,
            cookingTime: TimeInterval(10),
            servings: 2,
            category: .breakfast,
            ingredients: [ing1, ing2]
        )
        
        try await mockRecipeRepo.create(recipe: recipe)
        
        try await useCase.execute(recipeId: recipe.id, to: testCartId)
        
        let itemsInCart = mockCartRepo.getItemsInMock(cartId: testCartId)
        
        XCTAssertEqual(itemsInCart.count, 2)
        XCTAssertEqual(itemsInCart[0].name, "Milk")
        XCTAssertEqual(itemsInCart[1].name, "Eggs")
    }
    
    func test_removeFromCart_removesSpecificItem() async throws {
        let useCase = RemoveFromCartUseCase(repository: mockCartRepo)
        
        let item1 = Ingredient(id: UUID(), name: "Milk", amount: 1, unit: "l")
        let item2 = Ingredient(id: UUID(), name: "Bread", amount: 1, unit: "pc")
        
        try await mockCartRepo.add(ingredients: [item1, item2], to: testCartId)
        
        try await useCase.execute(id: item1.id, from: testCartId)
        
        let itemsInCart = mockCartRepo.getItemsInMock(cartId: testCartId)
        
        XCTAssertEqual(itemsInCart.count, 1)
        XCTAssertEqual(itemsInCart.first?.name, "Bread")
    }
    
    func test_getCartItems_returnsRepoItems() async throws {
        let useCase = GetCartItemsUseCase(repository: mockCartRepo)
        let item = Ingredient(name: "Test", amount: 1, unit: "")
        
        try await mockCartRepo.add(ingredient: item, to: testCartId)
        
        let results = try await useCase.execute(cartId: testCartId)
        
        XCTAssertEqual(results.count, 1)
    }
}
