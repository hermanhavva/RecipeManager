import Foundation
import UIKit

class IngredientTableDelegate: UIViewController {
    public var cellForRowAt: ((_ tableView: UITableView, _ indexPath: IndexPath) -> UITableViewCell)?;
}

//TODO: Replace fixed values
extension IngredientTableDelegate: UITableViewDelegate, UITableViewDataSource {
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        60
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        cellForRowAt?(tableView, indexPath) ?? UITableViewCell()
    }
}
