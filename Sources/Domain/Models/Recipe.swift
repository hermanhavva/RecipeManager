import Foundation

public struct Recipe: Identifiable, Codable, Equatable {
    public let id: UUID
    public let title: String
    public let description: String
    public let ingredients: [Ingredient]
    public var isFavorite: Bool
    public let createdAt: Date
    
    public init(id: UUID = UUID(), title: String, description: String, ingredients: [Ingredient], isFavorite: Bool = false, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.description = description
        self.ingredients = ingredients
        self.isFavorite = isFavorite
        self.createdAt = createdAt
    }
}
