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
        let ingredients = [CreateIngredientDTO(name: "A", amount: 1, unit: "kg")]
        let dto = CreateRecipeDTO(
            title: "Test Recipe",
            description: "Short desc",
            calories: 100,
            cookingTime: 300,
            servings: "2",
            category: .lunch,
            ingredients: ingredients
        )
        
        try await useCase.execute(dto: dto)
        
        XCTAssertEqual(mockRepo.items.count, 1)
        let savedRecipe = mockRepo.items.first
        XCTAssertEqual(savedRecipe?.title, "Test Recipe")
        XCTAssertEqual(savedRecipe?.calories, 100)
    }
    
    func test_createRecipe_emptyTitle_throwsError() async {
        let useCase = CreateRecipeUseCase(repository: mockRepo)
        
        let dto = CreateRecipeDTO(
            title: "",
            description: "D",
            calories: 100,
            cookingTime: 300,
            servings: "2",
            category: .lunch,
            ingredients: [CreateIngredientDTO(name: "A", amount: 1, unit: "kg")]
        )
        
        do {
            try await useCase.execute(dto: dto)
            XCTFail("Should fail")
        } catch let error as DomainError {
            XCTAssertTrue(error is RecipeConstraintValidationError)
        } catch {
            XCTFail("Wrong error type")
        }
    }
    
    func test_createRecipe_invalidNumbers_throwsError() async {
        let useCase = CreateRecipeUseCase(repository: mockRepo)
        
        let dto = CreateRecipeDTO(
            title: "Valid",
            description: "D",
            calories: 0,
            cookingTime: 10,
            servings: "2",
            category: .lunch,
            ingredients: [CreateIngredientDTO(name: "A", amount: 1, unit: "kg")]
        )
        
        do {
            try await useCase.execute(dto: dto)
            XCTFail("Should fail")
        } catch let error as DomainError {
            XCTAssertTrue(error is RecipeConstraintValidationError)
        } catch _ {
            XCTFail("Wrong error type")
        }
    }
    
    func test_getRecipes_returnsSortedByDate() async throws {
        let useCase = GetRecipesUseCase(repository: mockRepo)
        let oldDate = Date().addingTimeInterval(-1000)
        let newDate = Date()
        
        let oldRecipe = Recipe(
            title: "Old", description: "", calories: 1, cookingTime: 1, servings: 1, category: .snack, ingredients: [], createdAt: oldDate
        )
        let newRecipe = Recipe(
            title: "New", description: "", calories: 1, cookingTime: 1, servings: 1, category: .snack, ingredients: [], createdAt: newDate
        )
        
        mockRepo.items = [oldRecipe, newRecipe]
        
        let result = try await useCase.execute()
        
        XCTAssertEqual(result.first?.title, "New", "The newest recipe should be first")
        XCTAssertEqual(result.last?.title, "Old")
    }
    
    func test_toggleFavorite_switchesState() async throws {
        let useCase = ToggleFavoriteUseCase(repository: mockRepo)
        
        let recipe = Recipe(
            title: "Fav", description: "", calories: 1, cookingTime: 1, servings: 1, category: .snack, ingredients: [], isFavorite: false
        )
        mockRepo.items = [recipe]
        
        try await useCase.execute(recipeId: recipe.id)
        XCTAssertTrue(mockRepo.items.first!.isFavorite, "Should become true")
        
        try await useCase.execute(recipeId: recipe.id)
        XCTAssertFalse(mockRepo.items.first!.isFavorite, "Should become false")
    }
    
    func test_getFavourites_returnsOnlyFavoritesSortedByDate() async throws {
        let useCase = GetFavouriteRecipesUseCase(repository: mockRepo)
        let oldDate = Date().addingTimeInterval(-1000)
        let newDate = Date()
        
        let oldFav = Recipe(title: "Old Fav", description: "", calories: 1, cookingTime: 1, servings: 1, category: .snack, ingredients: [], isFavorite: true, createdAt: oldDate)
        let newFav = Recipe(title: "New Fav", description: "", calories: 1, cookingTime: 1, servings: 1, category: .snack, ingredients: [], isFavorite: true, createdAt: newDate)
        let nonFav = Recipe(title: "Non Fav", description: "", calories: 1, cookingTime: 1, servings: 1, category: .snack, ingredients: [], isFavorite: false, createdAt: newDate)
        
        mockRepo.items = [oldFav, nonFav, newFav]
        
        let result = try await useCase.execute()
        
        XCTAssertEqual(result.count, 2, "Should only return favorite recipes")
        XCTAssertEqual(result.first?.title, "New Fav", "Should be sorted by date (newest first)")
        XCTAssertEqual(result.last?.title, "Old Fav")
        XCTAssertFalse(result.contains { $0.title == "Non Fav" }, "Should not contain non-favorites")
    }
    
    func test_deleteRecipe_success() async throws {
        let useCase = DeleteRecipeUseCase(repository: mockRepo)
        let recipe = Recipe(
            title: "Recipe to Delete",
            description: "Desc",
            calories: 100,
            cookingTime: 300,
            servings: 2,
            category: .dinner,
            ingredients: []
        )
      
        mockRepo.items = [recipe]
        
        try await useCase.execute(recipeId: recipe.id)
        
        XCTAssertTrue(mockRepo.items.isEmpty, "Repository should be empty after deletion")
    }
    
    func test_deleteRecipe_notFound_throwsDomainError() async {
        
        let useCase = DeleteRecipeUseCase(repository: mockRepo)
        let nonExistentId = UUID()
        
        do {
            try await useCase.execute(recipeId: nonExistentId)
            XCTFail("Should have thrown error")
        }
        catch let error as DomainError {
            XCTAssertTrue(error is RecipeNotFoundError)
        }
        catch {
            XCTFail("Wrong error type: \(error)")
        }
    }
}

