import Foundation
import Combine
import Domain

public class RecipeListViewModel {
    // MARK: - internal types
    public typealias FetchStrategy = () async throws -> [Recipe]
    
    // MARK: - Properties
    private let fetchStrategy: FetchStrategy
    
    // Output
    @Published public var recipes: [Recipe] = []
    @Published public var errorMessage: String?
    @Published public var isLoading: Bool = false
    
    // MARK: - Init
    public init(fetchStrategy: @escaping FetchStrategy) {
        self.fetchStrategy = fetchStrategy
    }
    
    // MARK: - Actions
    public func loadData() {
        isLoading = true
        
        Task { [weak self] in
            guard let self = self else { return }
            
            do {
                let fetchedRecipes = try await self.fetchStrategy()
                
                await MainActor.run {
                    self.recipes = fetchedRecipes
                    self.isLoading = false
                }
            } catch {
                await MainActor.run {
                    self.errorMessage = error.localizedDescription
                    self.isLoading = false
                }
            }
        }
    }
}
