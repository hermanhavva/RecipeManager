public struct CreateIngredientDTO: Codable, Equatable {
    public let name: String
    public let amount: Int
    public let unit: String
    
    public init(name: String, amount: Int, unit: String) {
        self.name = name
        self.amount = amount
        self.unit = unit
    }
}
