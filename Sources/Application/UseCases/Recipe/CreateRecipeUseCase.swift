import Foundation
import Domain

public class CreateRecipeUseCase {
    private let repository: RecipeRepositoryType
    
    public init(repository: RecipeRepositoryType) {
        self.repository = repository
    }
    
    public func execute(dto: CreateRecipeDTO) async throws {
        do {
            let newRecipe = try RecipeMapper.mapToEntity(from: dto)
            try await repository.create(recipe: newRecipe)
        }
        catch let error as DomainError {
            throw error
        }
        catch {
            throw RecipeAppError.unknownError(underlying: error)
        }
    }
}
