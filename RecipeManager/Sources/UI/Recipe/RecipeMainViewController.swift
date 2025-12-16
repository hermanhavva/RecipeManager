import Foundation
import SnapKit
import UIKit

class RecipeMainViewController: RecipeFavoriteViewController {
    //TODO: add an action to the button
    let addRecipeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Додати рецепт", for: .normal)
        button.backgroundColor = buttonBackgroundColor
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = buttonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func setupUI() {
        super.setupUI()
        view.addSubview(addRecipeButton)
        label.text = "Рецепти"
        
        let topBaseOffset: Double = 30
        
        addRecipeButton.snp.makeConstraints{
            $0.width.equalTo(180)
            $0.height.equalTo(2*RecipeMainViewController.buttonCornerRadius)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(tableView.snp.bottom).offset(0.5*topBaseOffset)
        }
    }
}
