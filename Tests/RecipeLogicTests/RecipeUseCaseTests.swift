import XCTest
@testable import Domain
@testable import Application

final class RecipeUseCaseTests: XCTestCase {
    
    var mockRepo: MockRecipeRepository!
    
    override func setUp() {
        super.setUp()
        mockRepo = MockRecipeRepository()
    }
    
    func test_createRecipe_success() async throws {
        let useCase = CreateRecipeUseCase(repository: mockRepo)
        let ingredients = [Ingredient(name: "A", amount: "1", unit: "kg")]
        
        try await useCase.execute(
            title: "Test Recipe",
            description: "Do it",
            calories: 100,
            cookingTime: 10,
            servings: 2,
            category: .lunch,
            ingredients: ingredients
        )
        
        XCTAssertEqual(mockRepo.items.count, 1)
        XCTAssertEqual(mockRepo.items.first?.title, "Test Recipe")
    }
    
    func test_createRecipe_emptyTitle_throwsError() async {
        let useCase = CreateRecipeUseCase(repository: mockRepo)
        do {
            try await useCase.execute(
                title: "",
                description: "D", calories: 100, cookingTime: 10, servings: 2, category: .lunch,
                ingredients: [Ingredient(name: "A", amount: "1", unit: "kg")]
            )
            XCTFail("Should fail")
        } catch {
            XCTAssertEqual((error as NSError).code, 1)
        }
    }
    
    func test_createRecipe_invalidNumbers_throwsError() async {
        let useCase = CreateRecipeUseCase(repository: mockRepo)
        do {
            try await useCase.execute(
                title: "Valid", description: "D",
                calories: 0,
                cookingTime: 10, servings: 2, category: .lunch,
                ingredients: [Ingredient(name: "A", amount: "1", unit: "kg")]
            )
            XCTFail("Should fail")
        } catch {
            XCTAssertEqual((error as NSError).code, 4)
        }
    }
    
    func test_getRecipes_returnsSortedByDate() async throws {
        let useCase = GetRecipesUseCase(repository: mockRepo)
        let oldDate = Date().addingTimeInterval(-1000)
        let newDate = Date()
        
        let oldRecipe = Recipe(title: "Old", description: "", calories: 1, cookingTime: 1, servings: 1, category: .snack, ingredients: [], createdAt: oldDate)
        let newRecipe = Recipe(title: "New", description: "", calories: 1, cookingTime: 1, servings: 1, category: .snack, ingredients: [], createdAt: newDate)
        
        mockRepo.items = [oldRecipe, newRecipe]
        
        let result = try await useCase.execute()
        
        XCTAssertEqual(result.first?.title, "New", "The newest recipe should be first")
        XCTAssertEqual(result.last?.title, "Old")
    }
    
    func test_toggleFavorite_switchesState() async throws {
        let useCase = ToggleFavoriteUseCase(repository: mockRepo)
        let recipe = Recipe(title: "Fav", description: "", calories: 1, cookingTime: 1, servings: 1, category: .snack, ingredients: [], isFavorite: false)
        mockRepo.items = [recipe]
        
        try await useCase.execute(recipeId: recipe.id)
        XCTAssertTrue(mockRepo.items.first!.isFavorite, "Should become true")
        
        try await useCase.execute(recipeId: recipe.id)
        XCTAssertFalse(mockRepo.items.first!.isFavorite, "Should become false")
    }
}
