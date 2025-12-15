import Foundation

public struct Ingredient: Identifiable, Codable, Equatable {
    public let id: UUID
    public let name: String
    public let amount: Int
    public let unit: String
    
    public init(id: UUID = UUID(), name: String, amount: Int, unit: String) {
        self.id = id
        self.name = name
        self.amount = amount
        self.unit = unit
    }
    
    public func validate() throws {
        guard !name.isEmpty else {
            throw IngredientConstraintsValidationError(reason: "Name cannot be empty")
        }
        guard !(amount <= 0) else {
            throw IngredientConstraintsValidationError(reason: "Amount cannot be zero or negative")
        }
        guard !unit.isEmpty else {
            throw IngredientConstraintsValidationError(reason: "Unit cannot be empty")
        }
    }
}
