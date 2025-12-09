import Foundation
import Domain

public class ToggleFavoriteUseCase {
    private let repository: RecipeRepositoryType
    
    public init(repository: RecipeRepositoryType) {
        self.repository = repository
    }
    
    public func execute(recipeId: UUID) async throws {
        var recipes = try await repository.fetchRecipes()
        
        guard let index = recipes.firstIndex(where: { $0.id == recipeId }) else {
            return
        }
        var recipe = recipes[index]
        recipe.isFavorite.toggle()
        try await repository.update(recipe: recipe)
    }
}
