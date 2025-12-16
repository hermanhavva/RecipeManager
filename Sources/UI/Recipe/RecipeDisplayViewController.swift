import Foundation
import UIKit
import SnapKit
import SwiftUI
import Presentation
import Combine
import Domain
import Application


final class RecipeDisplayViewController: UIViewController {
    private let viewModel: RecipeDisplayViewModel
    private var cancellables = Set<AnyCancellable>()
    
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
    init(viewModel: RecipeDisplayViewModel){
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
        bindViewModel()
        setupActions()
    }
    func setupData() {
        let recipe = viewModel.recipe
        displayedRecipe.setup(with: recipe)
        segmentOption2.text = recipe.description
        segmentOption1.reloadData()
    }
    
    func setupActions() {
        addAllIngredientsToCartButton.addTarget(self, action: #selector(addToCartTapped), for: .touchUpInside)
            
        segmentedControl.addTarget(self, action: #selector(segmentChanged), for: .valueChanged)
    }
    
    @objc func addToCartTapped() {
        viewModel.addIngredientsToCart()
    }
    func bindViewModel() {
        viewModel.$isIngredientsAdded
            .receive(on: RunLoop.main)
            .sink { [weak self] isAdded in
            if isAdded {
                self?.showAlert(title: "Успіх", message: "Інгредієнти додано в корзину!")
            }
        }
        .store(in: &cancellables)
        
        viewModel.$errorMessage
            .compactMap { $0 }
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                self?.showAlert(title: "Помилка", message: message)
            }
            .store(in: &cancellables)
    }
    
    private func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
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
        ingredientTableDelegate.numberOfRows = { [weak self] in
            return self?.viewModel.recipe.ingredients.count ?? 0
        }
        ingredientTableDelegate.cellForRowAt = { [weak self] tableView, indexPath in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeIngredientTableCell") as? IngredientTableCell else {
                        return UITableViewCell()
        }
                    
            if let ingredient = self?.viewModel.recipe.ingredients[indexPath.row] {
                cell.name.text = ingredient.name
                cell.count.text = "\(ingredient.amount) \(ingredient.unit)"
                cell.setup(with: ingredient)
            }
                    
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
