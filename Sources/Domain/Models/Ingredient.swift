import Foundation

public struct Ingredient: Identifiable, Codable, Equatable {
    public let id: UUID
    public let name: String
    public let amount: String
    public let unit: String
    
    public init(id: UUID = UUID(), name: String, amount: String, unit: String) {
        self.id = id
        self.name = name
        self.amount = amount
        self.unit = unit
    }
}
