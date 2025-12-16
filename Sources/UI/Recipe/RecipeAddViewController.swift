import Foundation
import SnapKit
import UIKit

class RecipeAddViewController: UIViewController {
    
    let recipeNameTextField: UITextField = {
        let view = UITextField()
        view.placeholder = "Назва"
        view.borderStyle = .roundedRect
        view.keyboardType = .default
        view.returnKeyType = .done
        return view
    }()
    
    let addRecipeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Додати рецепт", for: .normal)
        button.backgroundColor = RecipeMainViewController.buttonBackgroundColor
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = RecipeMainViewController.buttonCornerRadius
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let calories: UITextField = {
        let view = UITextField()
        view.placeholder = "Ккал"
        view.backgroundColor = RecipeTableCell.caloriesBackgroundColor
        return applyTextStyle(view, .center)
    }()
    
    let timeTaken: UITextField = {
        let view = UITextField()
        view.placeholder = "Час(хв)"
        view.backgroundColor = RecipeTableCell.timeTakenBackgroundColor
        return applyTextStyle(view, .center)
    }()
    
    let forPeople: UITextField = {
        let view = UITextField()
        view.placeholder = "Порцій"
        view.backgroundColor = RecipeTableCell.portionsBackgroundColor
        return applyTextStyle(view, .center)
    }()
    
    static func applyTextStyle(_ view: UITextField, _ alignment: NSTextAlignment ) -> UITextField {
        view.borderStyle = .roundedRect
        view.keyboardType = .default
        view.returnKeyType = .done
        view.textAlignment = alignment
        view.font = RecipeTableCell.statsFont
        view.layer.cornerRadius = RecipeTableCell.statsCornerRadius
        return view
    }
    
    let descriptionLabel: UILabel = {
        let view = UILabel()
        view.text = "Приготування:"
        return view
    }()
    
    let recipeDescriptionTextView: UITextView = {
        let view = UITextView()
        view.layer.borderWidth = 1.0
        view.layer.borderColor = UIColor.lightGray.cgColor
        view.layer.cornerRadius = RecipeTableCell.statsCornerRadius
        view.layer.masksToBounds = true
        view.clipsToBounds = true
        return view
    }()
    
    let ingredientName: UITextField = {
        let view = UITextField()
        view.placeholder = "Інгредієнт"
        return applyTextStyle(view, .left)
    }()
    
    let amount: UITextField = {
        let view = UITextField()
        view.placeholder = "К-сть"
        return applyTextStyle(view, .left)
    }()
    
    let unit: UITextField = {
        let view = UITextField()
        view.placeholder = "г/мл/шт"
        return applyTextStyle(view, .left)
    }()
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupActions()
    }
    
    func setupActions() {
        //TODO: Here add a viewModel integration to save the recipe
    }
    
    func setupUI() {
        view.backgroundColor = .white
        view.addSubview(recipeNameTextField)
        view.addSubview(addRecipeButton)
        view.addSubview(calories)
        view.addSubview(timeTaken)
        view.addSubview(forPeople)
        view.addSubview(descriptionLabel)
        view.addSubview(recipeDescriptionTextView)
        view.addSubview(ingredientName)
        view.addSubview(amount)
        view.addSubview(unit)
        
        let topBaseOffset: Double = 50
        
        recipeNameTextField.snp.makeConstraints {
            $0.top.equalToSuperview().offset(topBaseOffset)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9)
        }
        
        addRecipeButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(topBaseOffset)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(180)
            $0.height.equalTo(2*RecipeMainViewController.buttonCornerRadius)
        }
        
        let statsHeight = 20
        let statsTop = 40
        let statsHorizontal = 20
        
        calories.snp.makeConstraints{
            $0.width.equalToSuperview().multipliedBy(0.25)
            $0.height.equalTo(statsHeight)
            $0.top.equalTo(recipeNameTextField.snp.bottom).offset(statsTop)
            $0.leading.equalToSuperview().offset(statsHorizontal)
        }
        
        timeTaken.snp.makeConstraints{
            $0.width.equalToSuperview().multipliedBy(0.25)
            $0.height.equalTo(statsHeight)
            $0.top.equalTo(recipeNameTextField.snp.bottom).offset(statsTop)
            $0.centerX.equalToSuperview()
        }
        
        forPeople.snp.makeConstraints{
            $0.width.equalToSuperview().multipliedBy(0.25)
            $0.height.equalTo(statsHeight)
            $0.top.equalTo(recipeNameTextField.snp.bottom).offset(statsTop)
            $0.trailing.equalToSuperview().inset(statsHorizontal)
        }
        
        ingredientName.snp.makeConstraints {
            $0.top.equalTo(calories.snp.bottom).offset(topBaseOffset)
            $0.leading.equalToSuperview().offset(10)
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
        
        amount.snp.makeConstraints {
            $0.top.equalTo(calories.snp.bottom).offset(topBaseOffset)
            $0.leading.equalTo(ingredientName.snp.trailing).offset(10)
            $0.width.equalToSuperview().multipliedBy(0.2)
        }
        
        unit.snp.makeConstraints {
            $0.top.equalTo(calories.snp.bottom).offset(topBaseOffset)
            $0.leading.equalTo(amount.snp.trailing).offset(10)
            $0.width.equalToSuperview().multipliedBy(0.2)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(ingredientName.snp.bottom).offset(topBaseOffset)
            $0.centerX.equalToSuperview()
        }
        
        recipeDescriptionTextView.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            $0.bottom.equalTo(addRecipeButton.snp.top).multipliedBy(0.9)
            $0.centerX.equalToSuperview()
            $0.width.equalToSuperview().multipliedBy(0.9)
        }
    }
}
