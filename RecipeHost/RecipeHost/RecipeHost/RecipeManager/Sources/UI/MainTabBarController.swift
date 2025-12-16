import Foundation
import SwiftUI
import Application
import Domain
import Presentation
import Infrastructure

class MainTabBarController: UITabBarController, RecipeNavigationDelegate {
    
    var makeDetailViewController: ((Recipe) -> UIViewController)?
    
    func didSelectRecipe(_ recipe: Recipe, in viewController: UIViewController) {
        // Use the factory to create the screen
        guard let destinationVC = makeDetailViewController?(recipe) else { return }
        
        // Push it using the navigation controller of the sender
        viewController.navigationController?.pushViewController(destinationVC, animated: true)
    }
}

@MainActor
func createTabBarController() -> UITabBarController {
    // MARK: Create Infrastructure
    let recipeRepository = RecipeJsonRepository()
    let cartRepository = CartJsonRepository()
    
    // MARK: Create Use Cases
    let getAllRecipesUseCase = GetRecipesUseCase(repository: recipeRepository)
    let getFavoritesUseCase = GetFavouriteRecipesUseCase(repository: recipeRepository)
    let addIngredientsUseCase = AddRecipeIngredientsToCartUseCase(cartRepository: cartRepository, recipeRepository: recipeRepository)
    let getCartItemsUseCase = GetCartItemsUseCase(repository: cartRepository)
    let addManualIngredientsUseCase = AddIngredientsToCartUseCase(repository: cartRepository)
    
    // MARK: Define the "Detail Screen Factory"
    let makeDetailScreen: @MainActor (Recipe) -> UIViewController = { recipe in
        let detailViewModel = RecipeDisplayViewModel(
            recipe: recipe,
            addRecipeToCartUseCase: addIngredientsUseCase
        )
        return RecipeDisplayViewController(viewModel: detailViewModel)
    }
    
    // MARK: Create ViewModels
    let mainViewModel = RecipeListViewModel(fetchStrategy: {
        try await getAllRecipesUseCase.execute()
    })
    
    let favoriteViewModel = RecipeListViewModel(fetchStrategy: {
        try await getFavoritesUseCase.execute()
    })
    
    let ingredientViewModel = IngredientStorageViewModel(
        getCartItemsUseCase: getCartItemsUseCase,
        addIngredientsToCartUseCase: addManualIngredientsUseCase
    )
    
    // MARK: Create View Controllers
    let recipeMainViewController = RecipeMainViewController(viewModel: mainViewModel)
    let recipeFavoriteViewController = RecipeFavoriteViewController(viewModel: favoriteViewModel)
    let ingredientStorageViewController = IngredientStorageViewController(viewModel: ingredientViewModel)
    
    
    // MARK: Setup Navigation & Tab Bar
    // CHANGE 1: Instantiate your CUSTOM controller, not the generic one
    let tabBarController = MainTabBarController()
    
    // CHANGE 2: Give the factory to the TabBar (the Delegate), not the children
    tabBarController.makeDetailViewController = makeDetailScreen
    
    // CHANGE 3: Wire up the delegates
    // "Hey child controllers, if someone clicks a recipe, tell the tabBarController!"
    recipeMainViewController.navigationDelegate = tabBarController
    recipeFavoriteViewController.navigationDelegate = tabBarController
    
    
    // Standard Navigation Setup
    let recipeMainNav = UINavigationController(rootViewController: recipeMainViewController)
    let ingrStorageNav = UINavigationController(rootViewController: ingredientStorageViewController)
    let recipeFavNav = UINavigationController(rootViewController: recipeFavoriteViewController)
    
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
