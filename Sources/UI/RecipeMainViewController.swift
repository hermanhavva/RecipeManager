//
//  RecipeMainViewController.swift
//
//
//  Created by Daniel Bond on 08.12.2025.
//

import Foundation
import SnapKit
import UIKit
import SwiftUI

final class RecipeMainViewController: UIViewController {
    //TODO: connect to a ViewModel and get real data
    
    let tableView = UITableView()
    
    let label: UILabel = {
        let view = UILabel()
        view.text = "Рецепти"
        view.font = .systemFont(ofSize: 30, weight: .regular)
        view.textColor = .black
        return view
    }()
    
    //TODO: add an action to the button
    let addRecipeButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Додати рецепт", for: .normal)
        button.backgroundColor = .init(red: 181/255, green: 227/255, blue: 194/255, alpha: 1)
        button.setTitleColor(.black, for: .normal)
        button.layer.cornerRadius = 20
        button.translatesAutoresizingMaskIntoConstraints = false
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
        view.addSubview(tableView)
        view.addSubview(addRecipeButton)
        
        label.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(30)
        }
        
        tableView.snp.makeConstraints{
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalTo(view.snp.centerY).offset(230)
            $0.top.equalTo(label.snp.bottom).offset(30)
        }
        
        addRecipeButton.snp.makeConstraints{
            $0.width.equalTo(180)
            $0.height.equalTo(40)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(tableView.snp.bottom).offset(15)
        }
        
        tableView.register(RecipeTableCell.self, forCellReuseIdentifier: "RecipeTableCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
}

//TODO: Replace fixed values
extension RecipeMainViewController: UITableViewDelegate, UITableViewDataSource {
    
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
        
        cell.setup(with: "Long Recipe Text Example Multiple Lines")
        
        return cell
        
    }
}


#Preview {
    RecipeMainViewController().asPreview()
}
