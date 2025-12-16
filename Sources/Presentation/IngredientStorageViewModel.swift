import Foundation
import Domain
import Application

public class IngredientStorageViewModel: ObservableObject {
    @Published public var ingredients: [ViewIngredientDTO] = []
    @Published public var errorMessage: String?
    
    private let getCartItemsUseCase: GetCartItemsUseCase
    private let addIngredientsToCartUseCase: AddIngredientsToCartUseCase
    private let defaultCartId = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
    public init(getCartItemsUseCase: GetCartItemsUseCase, addIngredientsToCartUseCase: AddIngredientsToCartUseCase) {
        self.getCartItemsUseCase = getCartItemsUseCase
        self.addIngredientsToCartUseCase = addIngredientsToCartUseCase
    }
    
    public func getCartItems(){
        Task {
            do {
                let entities = try await getCartItemsUseCase.execute(cartId: defaultCartId)
                ingredients = []
                for ingredient in entities {
                    ingredients.append(IngredientMapper.mapToViewDTO(from: ingredient))
                }
              
            }
            catch let error as LocalizedError {
                self.errorMessage = error.errorDescription
            }
            catch{
                self.errorMessage = error.localizedDescription
            }
        }
    }
    
    public func addIngredientsToCart(name: String, amount: Int, unit: String){
        Task {
            do {
                try await addIngredientsToCartUseCase.execute(ingredientDto: .init(name: name, amount: amount, unit: unit), to: defaultCartId)
                getCartItems()
            }
            catch let error as LocalizedError {
                self.errorMessage = error.errorDescription
            }
            catch{
                self.errorMessage = error.localizedDescription
            }
        }
    }
}
