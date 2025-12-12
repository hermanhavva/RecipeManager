import Foundation
import SwiftUI

func createTabBarController() -> UITabBarController{
    let tabBarController = UITabBarController()
    let recipeMainViewController = RecipeMainViewController()
    //TODO: Add here all the other views, using stubs instead
    let view2 = UIViewController()
    let view3 = UIViewController()
    //
    
    let recipeMainNav = UINavigationController(rootViewController: recipeMainViewController)
    //Stubs
    let view2Nav = UINavigationController(rootViewController: view2)
    let view3Nav = UINavigationController(rootViewController: view3)
    //
    
    recipeMainNav.tabBarItem = UITabBarItem(
        title: "", image: UIImage(systemName: "house"), tag: 0
    )
    //Stubs
    view2Nav.tabBarItem = UITabBarItem(
        title: "", image: UIImage(systemName: "cart"), tag: 1
    )
    view3Nav.tabBarItem = UITabBarItem(
        title: "", image: UIImage(systemName: "heart"), tag: 2
    )
    //
    
    tabBarController.viewControllers = [
        recipeMainNav,
        view2Nav,
        view3Nav
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
