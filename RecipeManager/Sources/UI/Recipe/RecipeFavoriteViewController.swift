import Foundation
import SnapKit
import UIKit
import Combine
import Domain
import Application
import Presentation

class RecipeFavoriteViewController: UIViewController {
    // MARK: - Properties
    private let viewModel: RecipeListViewModel
    private var cancellables = Set<AnyCancellable>()
    
    public var makeDetailViewController: (@MainActor (Recipe) -> UIViewController)?
    
    // MARK: - UI Constants
    static let labelFont: UIFont = .systemFont(ofSize: 30, weight: .regular)
    static let buttonBackgroundColor: UIColor = .init(red: 181/255, green: 227/255, blue: 194/255, alpha: 1)
    static let buttonCornerRadius: CGFloat = 20
    static let tableCellHeight: CGFloat = 170
        
    
    // MARK: - UI Elements
    let tableView = UITableView()
    
    let label: UILabel = {
        let view = UILabel()
        view.font = labelFont
        view.textColor = .black
        return view
    }()
    
    // MARK: - Init
    init(viewModel: RecipeListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Refresh data every time view appears (in case favorites changed)
        viewModel.loadData()
    }
    
    // MARK: - Setup
    func setupBindings() {
        viewModel.$recipes
            .receive(on: RunLoop.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
        
        // 2. Bind Errors to Alert
        viewModel.$errorMessage
            .compactMap { $0 } // Ignore nil
            .receive(on: RunLoop.main)
            .sink { [weak self] message in
                self?.showError(message)
            }
            .store(in: &cancellables)
    }
    
    func setupUI() {
        view.backgroundColor = .white // Ensure background is white
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
    
    private func showError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

// MARK: - TableView DataSource & Delegate
extension RecipeFavoriteViewController: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.recipes.count
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        RecipeFavoriteViewController.tableCellHeight
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeTableCell", for: indexPath) as? RecipeTableCell else {
            return UITableViewCell()
        }
        
        let recipe = viewModel.recipes[indexPath.row]
        cell.setup(with: recipe)
        
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recipe = viewModel.recipes[indexPath.row]
        
        // we use closure to create destination
        if let destinationVC = makeDetailViewController?(recipe) {
            // Push it onto the navigation stack
            self.navigationController?.pushViewController(destinationVC, animated: true)
        }
        
        self.tableView.deselectRow(at: indexPath, animated: true)
        
        
        // Navigation Logic:
        // We need to construct the next screen. Ideally, use a Coordinator or Factory.
        // For now, we will assume you can inject dependencies here or pass them down.
        // Note: You need access to AddRecipeIngredientsToCartUseCase here to create the next VM.
        
        // TODO: Replace 'MockCartRepository' with your real DI Container or Factory
        // This is a temporary wiring to make it compile:
#if DEBUG
        let cartRepo = MockCartRepository() // Replace with real repo
        let recipeRepo = MockRecipeRepository() // Replace with real repo
        let useCase = AddRecipeIngredientsToCartUseCase(cartRepository: cartRepo, recipeRepository: recipeRepo)
        
        let displayViewModel = RecipeDisplayViewModel(recipe: recipe, addRecipeToCartUseCase: useCase)
        let displayVC = RecipeDisplayViewController(viewModel: displayViewModel)
        
        // Present or Push
        // Since this is likely inside a NavigationController:
        // self.navigationController?.pushViewController(displayVC, animated: true)
        // Or generic presentation:
        present(displayVC, animated: true)
#endif
        
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
