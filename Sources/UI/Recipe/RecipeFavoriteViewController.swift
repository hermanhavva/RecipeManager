import Foundation
import SnapKit
import UIKit
import Combine
import Domain
import Application
import Presentation

public final class RecipeFavoriteViewController: RecipeBaseViewController {
    
    override func setupUI() {
        label.text = "Улюблені"
    }
}
