import Foundation
import UIKit
import SnapKit
import SwiftUI

final class RecipeDisplayViewController: UIViewController {
    var displayedRecipe: RecipeTableCell = RecipeTableCell()
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
        view.addSubview(displayedRecipe)
        displayedRecipe.snp.makeConstraints {
            $0.width.equalToSuperview()
            $0.top.equalToSuperview().offset(50)
            $0.centerX.equalToSuperview()
        }
    }
}

#Preview {
    RecipeDisplayViewController(recipe: "Recipe").asPreview()
}
