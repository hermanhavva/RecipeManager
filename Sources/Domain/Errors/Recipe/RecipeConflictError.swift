public final class RecipeConflictError: DomainError {
    public init(recipeTitle: String) {
        super.init(reason: "A recipe with the title '\(recipeTitle)' already exists.")
    }
    
    public required override init(reason: String) {
        super.init(reason: reason)
    }
}
