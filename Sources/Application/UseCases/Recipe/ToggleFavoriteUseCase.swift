import Foundation
import Domain

public class ToggleFavoriteUseCase {
    private let repository: RecipeRepositoryType
    
    public init(repository: RecipeRepositoryType) {
        self.repository = repository
    }
    
    public func execute(recipeId: UUID) async throws {
        do {
            let recipes = try await repository.get()
            
            guard let index = recipes.firstIndex(where: { $0.id == recipeId }) else {
                throw RecipeNotFoundError(reason: "Recipe with id: \(recipeId) not found")
            }
            
            var recipeToUpdate = recipes[index]
            recipeToUpdate.isFavorite.toggle()
            
            try await repository.update(recipe: recipeToUpdate)
            
        }
        catch let domainError as DomainError {
            throw domainError
        }
        catch {
            throw RecipeAppError.unknownError(underlying: error)
        }
    }
}
