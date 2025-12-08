//
//  RecipeTableCell.swift
//  
//
//  Created by Daniel Bond on 08.12.2025.
//

import Foundation
import UIKit
import SnapKit
import SwiftUI

final class RecipeTableCell: UITableViewCell {
    let name: UILabel = {
        let view = UILabel()
        view.font = .systemFont(ofSize: 22, weight: .semibold)
        view.numberOfLines = 0
        view.lineBreakMode = .byWordWrapping
        return view
    }()
    
    let calories: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 10, weight: .regular)
        view.backgroundColor = UIColor.init(red: 255/255, green: 241/255, blue: 218/255, alpha: 1)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    let timeTaken: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 10, weight: .regular)
        view.backgroundColor = UIColor.init(red: 218/255, green: 232/255, blue: 255/255, alpha: 1)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    let forPeople: UILabel = {
        let view = UILabel()
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 10, weight: .regular)
        view.backgroundColor = UIColor.init(red: 237/255, green: 218/255, blue: 255/255, alpha: 1)
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        return view
    }()
    
    let colorCircle: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 6
        return view
    }()
    
    let isFavorited: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    let roundedBackground: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 20
        view.layer.masksToBounds = false
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.3
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        view.layer.shadowRadius = 4
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
        
        roundedBackground.snp.makeConstraints {
            $0.top.equalToSuperview().inset(8)
            $0.bottom.equalToSuperview().inset(8)
            $0.leading.equalToSuperview().inset(16)
            $0.trailing.equalToSuperview().inset(16)
        }
        
        colorCircle.snp.makeConstraints{
            $0.width.height.equalTo(12)
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalToSuperview().offset(10)
        }
        
        name.snp.makeConstraints{
            $0.top.equalToSuperview().offset(20)
            $0.leading.equalTo(colorCircle.snp.trailing).offset(10)
            $0.trailing.equalTo(isFavorited.snp.leading).inset(10)
            $0.leadingMargin.equalTo(10)
            $0.trailingMargin.equalTo(20)
        }
        
        line.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(16)
            $0.trailing.equalToSuperview().inset(16)
            $0.height.equalTo(1)
            $0.top.equalTo(name.snp.bottom).offset(12)
        }
        
        
        // Here should be info from model, stub: true
        let stub = 1
        isFavorited.image = stub.isMultiple(of: 1) ? UIImage(systemName: "heart.fill") : UIImage(systemName: "heart")
        isFavorited.tintColor = .systemRed
        
        isFavorited.snp.makeConstraints{
            $0.width.height.equalTo(20)
            $0.bottom.equalTo(name.snp.bottom)
            $0.trailing.equalToSuperview().inset(20)
        }
        
        calories.snp.makeConstraints{
            $0.width.equalTo(50)
            $0.height.equalTo(20)
            $0.top.equalTo(line.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(50)
        }
        
        timeTaken.snp.makeConstraints{
            $0.width.equalTo(50)
            $0.height.equalTo(20)
            $0.top.equalTo(line.snp.bottom).offset(30)
            $0.centerX.equalToSuperview()
        }
        
        forPeople.snp.makeConstraints{
            $0.width.equalTo(50)
            $0.height.equalTo(20)
            $0.top.equalTo(line.snp.bottom).offset(30)
            $0.trailing.equalToSuperview().inset(50)
        }
        
    }
    
    // TODO: Pass the recipe here, change the input type, assign the values. Just a stub
    func setup(with recipe: String) {
        name.text = recipe
        colorCircle.backgroundColor = .green
        calories.text = "350"
        timeTaken.text = "15 хв"
        forPeople.text = "1"
    }
}
