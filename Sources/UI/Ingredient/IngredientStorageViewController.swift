import Foundation
import SnapKit
import UIKit

final class IngredientStorageViewController: UIViewController {
    
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
    
    init() {
        super.init(nibName: nil, bundle: nil)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        ingredientTableDelegate.cellForRowAt = { tableView, indexPath in
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "IngredientTableCell") as? IngredientTableCell else {
                return UITableViewCell()
            }
            
            cell.setup(with: "Приклад інгредієнту")
            
            return cell
        }
        
        tableView.register(IngredientTableCell.self, forCellReuseIdentifier: "IngredientTableCell")
        tableView.delegate = ingredientTableDelegate
        tableView.dataSource = ingredientTableDelegate
        tableView.separatorStyle = .none
    }
}
