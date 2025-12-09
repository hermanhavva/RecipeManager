import XCTest
@testable import Domain
@testable import Application

final class CartUseCaseTests: XCTestCase {
    
    var mockCartRepo: MockCartRepository!
    
    override func setUp() {
        super.setUp()
        mockCartRepo = MockCartRepository()
    }
    
    func test_addRecipeToCart_addsAllIngredients() async throws {
        let useCase = AddRecipeIngredientsToCartUseCase(repository: mockCartRepo)
        let ing1 = Ingredient(name: "Milk", amount: "1", unit: "l")
        let ing2 = Ingredient(name: "Eggs", amount: "2", unit: "pc")
        let recipe = Recipe(title: "Pancakes", description: "", calories: 100, cookingTime: 10, servings: 2, category: .breakfast, ingredients: [ing1, ing2])
        try await useCase.execute(recipe: recipe)
        XCTAssertEqual(mockCartRepo.items.count, 2)
        XCTAssertEqual(mockCartRepo.items[0].name, "Milk")
        XCTAssertEqual(mockCartRepo.items[1].name, "Eggs")
    }
    
    func test_removeFromCart_removesSpecificItem() async throws {
        let useCase = RemoveFromCartUseCase(repository: mockCartRepo)
        let item1 = Ingredient(id: UUID(), name: "Milk", amount: "1", unit: "l")
        let item2 = Ingredient(id: UUID(), name: "Bread", amount: "1", unit: "pc")
        mockCartRepo.items = [item1, item2]
        try await useCase.execute(id: item1.id)
        XCTAssertEqual(mockCartRepo.items.count, 1)
        XCTAssertEqual(mockCartRepo.items.first?.name, "Bread")
    }
    
    func test_getCartItems_returnsRepoItems() async throws {
        let useCase = GetCartItemsUseCase(repository: mockCartRepo)
        let item = Ingredient(name: "Test", amount: "1", unit: "")
        mockCartRepo.items = [item]
        
        let results = try await useCase.execute()
        
        XCTAssertEqual(results.count, 1)
    }
}
