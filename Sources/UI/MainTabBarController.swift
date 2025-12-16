import Foundation
import SwiftUI
import Application
import Domain
import Presentation
import Infrastructure

func createTabBarController() -> UITabBarController{
    // MARK: Create Infrastructure
    let recipeRepository = RecipeJsonRepository()
    let cartRepository = CartJsonRepository()
    
    //MARK: Create a Cart
    Task {
        do {
            try await cartRepository.create(cart: Cart(id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!, ingredients: []))
        }
        catch _ as CartConflictError{}//After first creation this will always be called
        catch{print("Failed to create a cart: \(error)")}
    }
    
    
    // MARK: Create Use Cases
    let getAllRecipesUseCase = GetRecipesUseCase(repository: recipeRepository)
    let getFavoritesUseCase = GetFavouriteRecipesUseCase(repository: recipeRepository)
    let addIngredientsUseCase = AddRecipeIngredientsToCartUseCase(cartRepository: cartRepository, recipeRepository: recipeRepository)
    let getCartItemsUseCase = GetCartItemsUseCase(repository: cartRepository)
    let addIngredientsToCartUseCase = AddIngredientsToCartUseCase(repository: cartRepository)
    let createReciepUseCase = CreateRecipeUseCase(repository: recipeRepository)
    
    
    // MARK: Define the "Detail Screen Factory"
    let makeDetailScreen: @MainActor (Recipe) -> UIViewController = { recipe in
        
        let detailViewModel = RecipeDisplayViewModel(
            recipe: recipe,
            addRecipeToCartUseCase: addIngredientsUseCase
        )
        return RecipeDisplayViewController(viewModel: detailViewModel)
    }
    
    // MARK: Create ViewModels
    // Strategy for Main Screen: "Get All"
    let mainViewModel = RecipeListViewModel(fetchStrategy: {
        try await getAllRecipesUseCase.execute()
    })
    
    // Strategy for Favorites Screen: "Get Favorites"
    let favoriteViewModel = RecipeListViewModel(fetchStrategy: {
        try await getFavoritesUseCase.execute()
    })
    
    let ingredientStorageViewModel = IngredientStorageViewModel(getCartItemsUseCase: getCartItemsUseCase, addIngredientsToCartUseCase: addIngredientsToCartUseCase)
    
    let recipeMainViewController = RecipeMainViewController(viewModel: mainViewModel)
    // inject factory
    recipeMainViewController.makeDetailViewController = makeDetailScreen
    
    let recipeFavoriteViewController = RecipeFavoriteViewController(viewModel: favoriteViewModel)
    // inject factory
    recipeFavoriteViewController.makeDetailViewController = makeDetailScreen
    
    let ingredientStorageViewController = IngredientStorageViewController(viewModel: ingredientStorageViewModel)
    
    let viewModel = RecipeAddViewModel(createRecipeUseCase: createReciepUseCase)
    
    // MARK: Setup Navigation & Tab Bar
    let tabBarController = UITabBarController()
    
    let recipeMainNav = UINavigationController(rootViewController: recipeMainViewController)
    let ingrStorageNav = UINavigationController(rootViewController: ingredientStorageViewController)
    let recipeFavNav = UINavigationController(rootViewController: recipeFavoriteViewController)
    
    recipeMainViewController.configure(viewModel: viewModel)
    
    recipeMainNav.tabBarItem = UITabBarItem(
        title: "", image: UIImage(systemName: "house"), tag: 0
    )
    ingrStorageNav.tabBarItem = UITabBarItem(
        title: "", image: UIImage(systemName: "cart"), tag: 1
    )
    recipeFavNav.tabBarItem = UITabBarItem(
        title: "", image: UIImage(systemName: "heart"), tag: 2
    )
    
    tabBarController.viewControllers = [
        recipeMainNav,
        ingrStorageNav,
        recipeFavNav
    ]
    
    // Custom Tab Bar styling
    tabBarController.setValue(MainTabBar(), forKey: "tabBar")
    tabBarController.tabBar.backgroundColor = RecipeMainViewController.buttonBackgroundColor
    
    return tabBarController
}

struct MainTabBarControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> some UIViewController {
        createTabBarController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) { }
}


class MainTabBar: UITabBar {

    private let height: CGFloat = 70
    private let horizontalInset: CGFloat = 20

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var size = super.sizeThatFits(size)
        size.height = height
        return size
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        let safeArea = self.superview?.safeAreaInsets.bottom ?? 0

        self.frame = CGRect(
            x: horizontalInset,
            y: self.superview!.bounds.height - height - safeArea,
            width: self.superview!.bounds.width - horizontalInset * 2,
            height: height
        )

        self.layer.cornerRadius = RecipeMainViewController.buttonCornerRadius
        self.layer.masksToBounds = true
    }
}
