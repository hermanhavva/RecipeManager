import Foundation
import Domain

public class GetRecipesUseCase {
    private let repository: RecipeRepositoryType
    
    public init(repository: RecipeRepositoryType) {
        self.repository = repository
    }
    
    public func execute() async throws -> [Recipe] {
        do {
            let recipes = try await repository.fetchRecipes()
            return recipes.sorted { $0.createdAt > $1.createdAt }
        } catch {
            throw RecipeAppError.dataLoadingError(underlying: error)
        }
    }
}
