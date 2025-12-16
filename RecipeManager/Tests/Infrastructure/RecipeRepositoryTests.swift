import XCTest
import Domain
import Application
import Infrastructure

final class RecipeRepositoryTests: XCTestCase {
    
    var repository: RecipeJsonRepository!
    var uniqueFileName: String!
    
    override func setUp() async throws {
        
        uniqueFileName = "test_recipes_\(UUID().uuidString)"
        repository = RecipeJsonRepository(fileName: uniqueFileName)
    }
    
    override func tearDown() async throws {
        
        if let filename = uniqueFileName {
            try removeTestFile(named: filename)
        }
    }
    
    // MARK: - Tests
    
    func test_CreateRecipe_Success() async throws {
        let recipe = createDummyRecipe(title: "Pancakes")
        
        try await repository.create(recipe: recipe)
        
        let fetched = try await repository.getById(id: recipe.id)
        XCTAssertNotNil(fetched)
        XCTAssertEqual(fetched?.title, "Pancakes")
    }
    
    func test_CreateRecipe_DuplicateTitle_ThrowsError() async throws {
        let recipe1 = createDummyRecipe(title: "Pancakes")
        let recipe2 = createDummyRecipe(title: "pancakes") // different casing
        
        try await repository.create(recipe: recipe1)
        
        do {
            try await repository.create(recipe: recipe2)
            XCTFail("Should have thrown RecipeConflictError")
        } catch let error as RecipeConflictError {
            // success
            print("Caught expected error: \(error)")
        } catch {
            XCTFail("Wrong error type thrown: \(error)")
        }
    }
    
    func test_DeleteRecipe_Success() async throws {
        let recipe = createDummyRecipe(title: "Soup")
        try await repository.create(recipe: recipe)
        
        try await repository.delete(recipeId: recipe.id)
        
        let fetched = try await repository.getById(id: recipe.id)
        XCTAssertNil(fetched)
    }
    
    func test_UpdateRecipe_NotFound_ThrowsError() async throws {
        let recipe = createDummyRecipe(title: "Ghost Pie")
        
        do {
            try await repository.update(recipe: recipe)
            XCTFail("Should have thrown RecipeNotFoundError")
        } catch is RecipeNotFoundError {
            // Success
        } catch {
            XCTFail("Wrong error type: \(error)")
        }
    }
    
    // MARK: - Helper
    private func createDummyRecipe(title: String) -> Recipe {
        return Recipe(
            title: title,
            description: "Delicious",
            calories: 100,
            cookingTime: 300,
            servings: 2,
            category: .breakfast,
            ingredients: []
        )
    }
}
