import Foundation

public class DeleteRecipeUseCase {
    private let repository: RecipeRepositoryType
    
    public init(repository: RecipeRepositoryType) {
        self.repository = repository
    }
    
    public func execute(recipeId: UUID) async throws {
        try await repository.delete(recipeId: recipeId)
    }
}
