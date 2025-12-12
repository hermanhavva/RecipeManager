import Foundation
import UIKit
import SnapKit
import SwiftUI

final class RecipeTableCell: UITableViewCell {
    // MARK: Replacing magic constants with variables
    static let nameFont: UIFont = .systemFont(ofSize: 22, weight: .semibold)
    
    static let statsFont: UIFont = .systemFont(ofSize: 10, weight: .regular)
    static let statsCornerRadius: CGFloat = 10
    
    static let caloriesBackgroundColor: UIColor = .init(red: 255/255, green: 241/255, blue: 218/255, alpha: 1)
    static let timeTakenBackgroundColor: UIColor = .init(red: 218/255, green: 232/255, blue: 255/255, alpha: 1)
    static let portionsBackgroundColor: UIColor = .init(red: 237/255, green: 218/255, blue: 255/255, alpha: 1)
    
    static let backgroundCornerRadius: CGFloat = 20
    static let backgroundShadowOpacity: Float = 0.3
    static let backgroundShadowOffset: CGFloat = 4
    
    static let colorCircleRadius: CGFloat = 6
    // MARK: UI
    let name: UILabel = {
        let view = UILabel()
        view.font = nameFont
        view.numberOfLines = 0 // Needed to wrap lines
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    
    let calories: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = statsFont
        view.backgroundColor = caloriesBackgroundColor
        view.layer.cornerRadius = statsCornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    let timeTaken: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = statsFont
        view.backgroundColor = timeTakenBackgroundColor
        view.layer.cornerRadius = statsCornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    let forPeople: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = statsFont
        view.backgroundColor = portionsBackgroundColor
        view.layer.cornerRadius = statsCornerRadius
        view.clipsToBounds = true
        return view
    }()
    
    let colorCircle: UIView = {
        let view = UIView()
        view.layer.cornerRadius = colorCircleRadius
        return view
    }()
    
    let isFavorited: UIImageView = {
        let view = UIImageView()
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
        super.init(style: .default, reuseIdentifier: reuseIdentifier ?? "RecipeTableCell")
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupUI(){
        let line = UIView()
        line.backgroundColor = .lightGray
        contentView.addSubview(roundedBackground)
        contentView.backgroundColor = .clear
        backgroundColor = .clear
        roundedBackground.addSubview(name)
        roundedBackground.addSubview(calories)
        roundedBackground.addSubview(timeTaken)
        roundedBackground.addSubview(forPeople)
        roundedBackground.addSubview(colorCircle)
        roundedBackground.addSubview(isFavorited)
        roundedBackground.addSubview(line)
        
        let roundedBackgroundBaseInset = 8
        roundedBackground.snp.makeConstraints {
            $0.top.equalToSuperview().inset(roundedBackgroundBaseInset)
            $0.bottom.equalToSuperview().inset(roundedBackgroundBaseInset)
            $0.leading.equalToSuperview().inset(2*roundedBackgroundBaseInset)
            $0.trailing.equalToSuperview().inset(2*roundedBackgroundBaseInset)
        }
        
        let colorCircleBaseOffset = 10
        colorCircle.snp.makeConstraints{
            $0.width.height.equalTo(2*RecipeTableCell.colorCircleRadius)
            $0.top.equalToSuperview().offset(2*colorCircleBaseOffset)
            $0.leading.equalToSuperview().offset(colorCircleBaseOffset)
        }
        
        let nameBaseConstraint = 10
        name.snp.makeConstraints{
            $0.top.equalToSuperview().offset(2*nameBaseConstraint)
            $0.leading.equalTo(colorCircle.snp.trailing).offset(nameBaseConstraint)
            $0.trailing.equalTo(isFavorited.snp.leading).inset(nameBaseConstraint)
            $0.leadingMargin.equalTo(nameBaseConstraint)
            $0.trailingMargin.equalTo(2*nameBaseConstraint)
        }
        
        let dividerBaseConstraint = 4
        line.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(4*dividerBaseConstraint)
            $0.trailing.equalToSuperview().inset(4*dividerBaseConstraint)
            $0.height.equalTo(1)
            $0.top.equalTo(name.snp.bottom).offset(3*dividerBaseConstraint)
        }
        
        let favoriteInset = 20
        isFavorited.snp.makeConstraints{
            $0.width.height.equalTo(20)
            $0.bottom.equalTo(name.snp.bottom)
            $0.trailing.equalToSuperview().inset(favoriteInset)
        }
        
        let statsWidth = 50
        let statsHeight = 20
        let statsTop = 30
        let statsHorizontal = 50
        
        calories.snp.makeConstraints{
            $0.width.equalTo(statsWidth)
            $0.height.equalTo(statsHeight)
            $0.top.equalTo(line.snp.bottom).offset(statsTop)
            $0.leading.equalToSuperview().offset(statsHorizontal)
        }
        
        timeTaken.snp.makeConstraints{
            $0.width.equalTo(statsWidth)
            $0.height.equalTo(statsHeight)
            $0.top.equalTo(line.snp.bottom).offset(statsTop)
            $0.centerX.equalToSuperview()
        }
        
        forPeople.snp.makeConstraints{
            $0.width.equalTo(statsWidth)
            $0.height.equalTo(statsHeight)
            $0.top.equalTo(line.snp.bottom).offset(statsTop)
            $0.trailing.equalToSuperview().inset(statsHorizontal)
        }
        
    }
    
    // TODO: Pass the recipe here, change the input type, assign the values. Just a stub
    func setup(with recipe: String) {
        name.text = recipe
        colorCircle.backgroundColor = .green
        calories.text = "350"
        timeTaken.text = "15 хв"
        forPeople.text = "1"
        //stub: true
        let stub = 1
        isFavorited.image = stub.isMultiple(of: 1) ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        isFavorited.tintColor = .systemRed
        
    }
}
