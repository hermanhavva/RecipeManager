import Foundation
import Domain

public class GetRecipesUseCase {
    private let repository: RecipeRepositoryType
    
    public init(repository: RecipeRepositoryType) {
        self.repository = repository
    }
    
    public func execute() async throws -> [Recipe] {
        do {
            let recipes = try await repository.getAll()
            
            return recipes.sorted { $0.createdAt > $1.createdAt }
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
