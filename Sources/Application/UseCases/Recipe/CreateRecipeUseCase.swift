import Foundation
import Domain

public class CreateRecipeUseCase {
    private let repository: RecipeRepositoryType
    
    public init(repository: RecipeRepositoryType) {
        self.repository = repository
    }
    
    public func execute(dto: CreateRecipeDTO) async throws {
        let newRecipe = RecipeMapper.mapToEntity(dto: dto)
        try newRecipe.validate()
        do {
            try await repository.add(recipe: newRecipe)
        } catch {
            throw RecipeAppError.dataLoadingError(underlying: error)
        }
    }
}
