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
    
    let tableView = UITableView()
    
    let label: UILabel = {
        let view = UILabel()
        view.text = "Рецепти"
        view.font = .systemFont(ofSize: 30, weight: .regular)
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
        
        label.snp.makeConstraints{
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(30)
        }
        
        tableView.snp.makeConstraints{
            $0.leading.trailing.bottom.equalToSuperview()
            $0.top.equalTo(label.snp.bottom).offset(30)
        }
        
        tableView.register(RecipeTableCell.self, forCellReuseIdentifier: "RecipeTableCell")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
    }
}

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
