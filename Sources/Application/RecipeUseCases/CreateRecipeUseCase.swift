import Foundation
import Domain

public class CreateRecipeUseCase {
    private let repository: RecipeRepositoryType
    
    public init(repository: RecipeRepositoryType) {
        self.repository = repository
    }
    public func execute(dto: CreateRecipeDTO) async throws {
        let newRecipe = try RecipeMapper.map(dto: dto)
        try await repository.add(recipe: newRecipe)
    }
}
