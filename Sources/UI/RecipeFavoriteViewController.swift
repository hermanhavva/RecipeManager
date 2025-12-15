import Foundation
import SnapKit
import UIKit

class RecipeFavoriteViewController: UIViewController {
    // MARK: constants
    static let labelFont: UIFont = .systemFont(ofSize: 30, weight: .regular)
    
    static let buttonBackgroundColor: UIColor = .init(red: 181/255, green: 227/255, blue: 194/255, alpha: 1)
    static let buttonCornerRadius: CGFloat = 20
    
    // MARK: UI
    //TODO: connect to a ViewModel and get real data
    let tableView = UITableView()
    
    let label: UILabel = {
        let view = UILabel()
        view.font = labelFont
        view.textColor = .black
        return view
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
        view.addSubview(tableView)
        
        let topBaseOffset: Double = 30
        
        label.text = "Улюблені"
        
        label.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(topBaseOffset)
        }
        
        tableView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.snp.centerY).offset(230)
            $0.top.equalTo(label.snp.bottom).offset(topBaseOffset)
        }
        
        tableView.register(RecipeTableCell.self, forCellReuseIdentifier: "RecipeTableCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
}

//TODO: Replace fixed values
//TODO: The list of recipes should be filtered if this is favorite instance
// Something like recipes.filter { $0.isFavorite }
extension RecipeFavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        170
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableCell") as? RecipeTableCell else {
            return UITableViewCell()
        }
        
        cell.setup(with: "Приклад довгої назви рецепту на два рядки")
        
        return cell
        
    }
}
