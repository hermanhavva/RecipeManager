public struct CreateIngredientDTO: Codable, Equatable {
    public let name: String
    public let amount: String
    public let unit: String
    
    public init(name: String, amount: String, unit: String) {
        self.name = name
        self.amount = amount
        self.unit = unit
    }
}
