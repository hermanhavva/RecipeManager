import Foundation
import SwiftUI

func createTabBarController() -> UITabBarController{
    let tabBarController = UITabBarController()
    
    let recipeMainViewController = RecipeMainViewController()
    let ingredientStorageViewController = IngredientStorageViewController()
    let recipeFavoriteViewController = RecipeFavoriteViewController()
    
    let recipeMainNav = UINavigationController(rootViewController: recipeMainViewController)
    let ingrStorageNav = UINavigationController(rootViewController: ingredientStorageViewController)
    let recipeFavNav = UINavigationController(rootViewController: recipeFavoriteViewController)
    
    recipeMainNav.tabBarItem = UITabBarItem(
        title: "", image: UIImage(systemName: "house"), tag: 0
    )
    ingrStorageNav.tabBarItem = UITabBarItem(
        title: "", image: UIImage(systemName: "cart"), tag: 1
    )
    // Stub
    recipeFavNav.tabBarItem = UITabBarItem(
        title: "", image: UIImage(systemName: "heart"), tag: 2
    )
    //
    
    tabBarController.viewControllers = [
        recipeMainNav,
        ingrStorageNav,
        recipeFavNav
    ]
    
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
