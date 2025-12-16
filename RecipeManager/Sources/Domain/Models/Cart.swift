import Foundation

public struct Cart : Identifiable, Codable, Equatable{
    public let id : UUID
    public var ingredients: [Ingredient] = []
    
    public init(id: UUID, ingredients: [Ingredient] = []) {
        self.id = id
        self.ingredients = ingredients
    }
}
