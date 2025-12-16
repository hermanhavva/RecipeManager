import Foundation
import Application
import SnapKit
import UIKit
import Presentation
import Combine
import Domain
import Application

final class IngredientStorageViewController: UIViewController {
    private let viewModel: IngredientStorageViewModel
    private var cancellables = Set<AnyCancellable>()
    
    static let labelFont: UIFont = .systemFont(ofSize: 30, weight: .regular)
    
    let ingredientTableDelegate = IngredientTableDelegate()
    
    let tableView = UITableView()
    
    let label: UILabel = {
        let view = UILabel()
        view.text = "Корзина"
        view.font = labelFont
        view.textColor = .black
        return view
    }()
    
    //TODO: add an action to the button
    let addIngredientButton: UIButton = {
        let button = UIButton(type: .system)
            let image = UIImage(
                systemName: "plus",
                withConfiguration: UIImage.SymbolConfiguration(pointSize: 15, weight: .bold)
            )
            button.setImage(image, for: .normal)
            button.tintColor = .gray
            return button
    }()
    
    init(viewModel: IngredientStorageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
        bindViewModel()
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupActions() {
        addIngredientButton.addTarget(self, action: #selector(addIngredient), for: .touchUpInside)
    }
    
    @objc func addIngredient() {
        //TODO: Get user input
        let name = "Ingredient"
        let amount = 1
        let unit = "kg"
        viewModel.addIngredientsToCart(name: name, amount: amount, unit: unit)
    }
    
    func setupData() {
        viewModel.getCartItems()
        tableView.reloadData()
    }
    
    func bindViewModel() {
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
    
    func setupUI() {
        view.addSubview(label)
        view.addSubview(addIngredientButton)
        view.addSubview(tableView)
        
        let baseOffset: Double = 30

        label.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(baseOffset)
        }
        
        addIngredientButton.snp.makeConstraints{
            $0.top.equalTo(label.snp.bottom).offset(baseOffset)
            $0.trailing.equalToSuperview().inset(baseOffset)
        }
        
        tableView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.snp.centerY).offset(230)
            $0.top.equalTo(addIngredientButton.snp.bottom).offset(baseOffset)
        }
        
        ingredientTableDelegate.numberOfRows = { [weak self] in
            return self?.viewModel.ingredients.count ?? 0
        }
        
        ingredientTableDelegate.cellForRowAt = { [weak self] tableView, indexPath in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientTableCell") as? IngredientTableCell else {
                return UITableViewCell()
            }
            
            if let ingredient = self?.viewModel.ingredients[indexPath.row] {
                cell.setup(with: ingredient)
            }
            
            return cell
        }
        
        tableView.register(IngredientTableCell.self, forCellReuseIdentifier: "IngredientTableCell")
        tableView.delegate = ingredientTableDelegate
        tableView.dataSource = ingredientTableDelegate
        tableView.separatorStyle = .none
    }
}
