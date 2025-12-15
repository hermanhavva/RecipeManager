import Foundation
import UIKit
import SnapKit
import SwiftUI

final class RecipeDisplayViewController: UIViewController {
    let displayedRecipe: RecipeTableCell = RecipeTableCell()
    let ingredientTableDelegate = IngredientTableDelegate()

    let segmentedControl: UISegmentedControl = {
        let view = UISegmentedControl(items: ["Інгредієнти", "Приготування"])
        view.selectedSegmentIndex = 0
        view.selectedSegmentTintColor = .white
        view.backgroundColor = .systemGray6
        return view
    }()
    
    //TODO: add an action to the button
    let addAllIngredientsToCartButton: UIButton = {
        let button = UIButton(type: .system)
            let image = UIImage(
                systemName: "cart",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .bold)
            )
            button.setImage(image, for: .normal)
            button.tintColor = .gray
            return button
    }()
    
    let segmentedContainer = UIView()
    
    let segmentOption1 = UITableView()
    
    let segmentOption2: UITextView = {
        let view = UITextView()
        view.font = IngredientTableCell.textFont
        view.backgroundColor = RecipeFavoriteViewController.buttonBackgroundColor
        view.layer.cornerRadius = RecipeTableCell.backgroundCornerRadius
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = RecipeTableCell.backgroundShadowOpacity
        view.layer.shadowOffset = CGSize(width: 0, height: RecipeTableCell.backgroundShadowOffset)
        view.layer.shadowRadius = RecipeTableCell.backgroundShadowOffset
        let inset: CGFloat = 15
        view.textContainerInset = .init(top: inset, left: inset, bottom: inset, right: inset)
        view.isEditable = false
        return view
    }()
    

    //TODO: change to the real recipe
    init(recipe: String){
        super.init(nibName: nil, bundle: nil)
        displayedRecipe.setup(with: recipe)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        let recipeCard = displayedRecipe.contentView
        recipeCard.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(recipeCard)
        view.addSubview(addAllIngredientsToCartButton)
        view.addSubview(segmentedControl)
        view.addSubview(segmentedContainer)
        view.backgroundColor = .white
        let baseOffset: Double = 25
        recipeCard.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.height.equalTo(RecipeFavoriteViewController.tableCellHeight)
            $0.top.equalToSuperview().offset(2*baseOffset)
            $0.centerX.equalToSuperview()
        }
        
        addAllIngredientsToCartButton.snp.makeConstraints {
            $0.top.equalTo(recipeCard.snp.bottom).offset(baseOffset)
            $0.trailing.equalToSuperview().inset(baseOffset)
        }
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(addAllIngredientsToCartButton.snp.bottom).offset(baseOffset)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().inset(30)
        }
        
        segmentedControl.addTarget(
            self,
            action: #selector(segmentChanged),
            for: .valueChanged
        )
        
        segmentedContainer.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(baseOffset)
            $0.bottom.equalToSuperview().inset(120)
            $0.leading.trailing.equalToSuperview()
        }
        
        segmentOption2.text = 
"""
Multiline recipe
About those ingredients
"""
        
        ingredientTableDelegate.cellForRowAt = {
            tableView, indexPath in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeIngredientTableCell") as? IngredientTableCell else {
                return UITableViewCell()
            }
            
            cell.setup(with: "Приклад інгредієнту")
            
            return cell
        }
        
        segmentOption1.register(IngredientTableCell.self, forCellReuseIdentifier: "RecipeIngredientTableCell")
        segmentOption1.delegate = ingredientTableDelegate
        segmentOption1.dataSource = ingredientTableDelegate
        segmentOption1.separatorStyle = .none
        
        show(segmentOption1)
    }
    
    @objc func segmentChanged(_ sender: UISegmentedControl){
        switch sender.selectedSegmentIndex {
            case 0:
                show(segmentOption1)
            case 1:
                show(segmentOption2)
            default:
                break
        }
    }
    
    func show(_ content: UIView) {
        segmentedContainer.subviews.forEach { $0.removeFromSuperview() }
        segmentedContainer.addSubview(content)

        content.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(10)
            $0.trailing.equalToSuperview().inset(10)
        }
    }
}

#Preview {
    RecipeDisplayViewController(recipe: "Recipe").asPreview()
}
