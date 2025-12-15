import Foundation
import Domain

public struct IngredientMapper{
    public static func mapToEntity(from dto: CreateIngredientDTO) throws -> Ingredient {
        
        let ingredient = Ingredient(
            id: UUID(),
            name: dto.name,
            amount: dto.amount,
            unit: dto.unit
        )
        
        try ingredient.validate()
        
        return ingredient
    }
}
