import Foundation
import Domain

public class DeleteRecipeUseCase {
    private let repository: RecipeRepositoryType
    
    public init(repository: RecipeRepositoryType) {
        self.repository = repository
    }
    
    public func execute(recipeId: UUID) async throws {
        do {
            try await repository.delete(recipeId: recipeId)
        }
        catch let error as DomainError {
            throw error
        }
        catch let error as RecipeAppError {
            throw error
        }
        catch {
            throw RecipeAppError.unknownError(underlying: error)
        }
    }
}
