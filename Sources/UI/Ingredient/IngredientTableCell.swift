import Foundation
import UIKit
import SnapKit
import Domain

final class IngredientTableCell: UITableViewCell {
    // MARK: Replacing magic constants with variables
    static let textFont: UIFont = .systemFont(ofSize: 16, weight: .regular)
    
    static let countBackgroundColor: UIColor = .init(red: 241/255, green: 241/255, blue: 241/255, alpha: 1)
    static let countCornerRadius: CGFloat = 10
    
    static let backgroundCornerRadius: CGFloat = 10
    static let backgroundShadowOpacity: Float = 0.3
    static let backgroundShadowOffset: CGFloat = 4
    
    static let colorCircleRadius: CGFloat = 3
    // MARK: UI
    let name: UILabel = {
        let view = UILabel()
        view.font = textFont
        return view
    }()
    
    let count: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = textFont
        view.backgroundColor = countBackgroundColor
        view.layer.cornerRadius = countCornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    let colorCircle: UIView = {
        let view = UIView()
        view.layer.cornerRadius = colorCircleRadius
        return view
    }()
    
    let roundedBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = backgroundCornerRadius
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = backgroundShadowOpacity
        view.layer.shadowOffset = CGSize(width: 0, height: backgroundShadowOffset)
        view.layer.shadowRadius = backgroundShadowOffset
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .default, reuseIdentifier: reuseIdentifier ?? "IngredientTableCell")
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        contentView.addSubview(roundedBackground)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        roundedBackground.addSubview(colorCircle)
        roundedBackground.addSubview(name)
        roundedBackground.addSubview(count)
        
        let roundedBackgroundBaseInset = 8
        roundedBackground.snp.makeConstraints {
            $0.top.equalToSuperview().inset(roundedBackgroundBaseInset)
            $0.bottom.equalToSuperview().inset(roundedBackgroundBaseInset)
            $0.leading.equalToSuperview().inset(2*roundedBackgroundBaseInset)
            $0.trailing.equalToSuperview().inset(2*roundedBackgroundBaseInset)
        }
        
        let colorCircleBaseOffset = 10
        colorCircle.snp.makeConstraints{
            $0.width.height.equalTo(2*IngredientTableCell.colorCircleRadius)
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(colorCircleBaseOffset)
        }
        
        let nameBaseConstraint = 10
        name.snp.makeConstraints{
            $0.centerY.equalToSuperview()
            $0.leading.equalTo(colorCircle.snp.trailing).offset(nameBaseConstraint)
        }
        
        let countWidth = 50
        let countHeight = 20
        
        count.snp.makeConstraints{
            $0.width.equalTo(countWidth)
            $0.height.equalTo(countHeight)
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(10)
        }
    }
    
    // TODO: Pass the recipe here, change the input type, assign the values. Just a stub
    func setup(with ingredient: Ingredient) {
        name.text = ingredient.name
        colorCircle.backgroundColor = .systemGreen
        count.text = "\(ingredient.amount) \(ingredient.unit)"
    }
}
