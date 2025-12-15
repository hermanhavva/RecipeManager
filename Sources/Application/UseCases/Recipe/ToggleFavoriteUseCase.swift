import Foundation
import Domain

public class ToggleFavoriteUseCase {
    private let repository: RecipeRepositoryType
    
    public init(repository: RecipeRepositoryType) {
        self.repository = repository
    }
    
    public func execute(recipeId: UUID) async throws {
        do {
            let recipes = try await repository.fetchRecipes()
            
            guard let index = recipes.firstIndex(where: { $0.id == recipeId }) else {
                throw RecipeDomainError.recipeNotFound
            }
            
            var recipeToUpdate = recipes[index]
            recipeToUpdate.isFavorite.toggle()
            
            try await repository.update(recipe: recipeToUpdate)
            
        } catch let domainError as RecipeDomainError {
            throw domainError
        } catch {
            throw RecipeAppError.dataLoadingError(underlying: error)
        }
    }
}
