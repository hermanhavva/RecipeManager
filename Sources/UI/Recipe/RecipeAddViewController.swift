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
    
    let ingredient1Name: UITextField = {
        let view = UITextField()
        view.placeholder = "Інгредієнт"
        return applyTextStyle(view, .left)
    }()
    
    let amount1: UITextField = {
        let view = UITextField()
        view.placeholder = "К-сть"
        return applyTextStyle(view, .left)
    }()
    
    let unit1: UITextField = {
        let view = UITextField()
        view.placeholder = "г/мл/шт"
        return applyTextStyle(view, .left)
    }()
    
    let ingredient2Name: UITextField = {
        let view = UITextField()
        view.placeholder = "Інгредієнт"
        return applyTextStyle(view, .left)
    }()
    
    let amount2: UITextField = {
        let view = UITextField()
        view.placeholder = "К-сть"
        return applyTextStyle(view, .left)
    }()
    
    let unit2: UITextField = {
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
        addRecipeButton.addTarget(self, action: #selector(addRecipe), for: .touchUpInside)
    }
    
    @objc func addRecipe() {
        //TODO: Here add a viewModel integration to save the recipe
        let recipeName = recipeNameTextField.text
        let calories = calories.text
        let time = timeTaken.text
        let servings = forPeople.text
        let ingredient1 = [ingredient1Name.text, amount1.text, unit1.text]
        let ingredient2 = [ingredient2Name.text, amount2.text, unit2.text]
        let description = recipeDescriptionTextView.text
        // Pass all these as parameters for recipe
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
        view.addSubview(ingredient1Name)
        view.addSubview(amount1)
        view.addSubview(unit1)
        view.addSubview(ingredient2Name)
        view.addSubview(amount2)
        view.addSubview(unit2)
        
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
        
        ingredient1Name.snp.makeConstraints {
            $0.top.equalTo(calories.snp.bottom).offset(topBaseOffset)
            $0.leading.equalToSuperview().offset(10)
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
        
        amount1.snp.makeConstraints {
            $0.top.equalTo(calories.snp.bottom).offset(topBaseOffset)
            $0.leading.equalTo(ingredient1Name.snp.trailing).offset(10)
            $0.width.equalToSuperview().multipliedBy(0.2)
        }
        
        unit1.snp.makeConstraints {
            $0.top.equalTo(calories.snp.bottom).offset(topBaseOffset)
            $0.leading.equalTo(amount1.snp.trailing).offset(10)
            $0.width.equalToSuperview().multipliedBy(0.2)
        }
        
        ingredient2Name.snp.makeConstraints {
            $0.top.equalTo(ingredient1Name.snp.bottom).offset(topBaseOffset)
            $0.leading.equalToSuperview().offset(10)
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
        
        amount2.snp.makeConstraints {
            $0.top.equalTo(ingredient1Name.snp.bottom).offset(topBaseOffset)
            $0.leading.equalTo(ingredient1Name.snp.trailing).offset(10)
            $0.width.equalToSuperview().multipliedBy(0.2)
        }
        
        unit2.snp.makeConstraints {
            $0.top.equalTo(ingredient1Name.snp.bottom).offset(topBaseOffset)
            $0.leading.equalTo(amount1.snp.trailing).offset(10)
            $0.width.equalToSuperview().multipliedBy(0.2)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(ingredient2Name.snp.bottom).offset(topBaseOffset)
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
