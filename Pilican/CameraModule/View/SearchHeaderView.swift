//
//  SearchHeaderView.swift
//  Pilican
//
//  Created by kairzhan on 4/28/21.
//

import UIKit

class SearchHeaderView: UITableViewHeaderFooterView {
    let searchBar: SearchBar = {
        let searchBar = SearchBar()
        searchBar.placeholder = "Введите идентификатор"
        searchBar.cornerRadius = 10
        searchBar.keyboardType = .numberPad
        return searchBar
    }()
    
    let searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("Поиск", for: .normal)
        button.backgroundColor = .primary
        button.setTitleColor(.pilicanWhite, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        setupInitialLayouts()
    }

    private func setupInitialLayouts() {
        addSubview(searchButton)
        searchButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(10)
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
            make.height.equalTo(36)
        }
        
        addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(10)
            make.right.equalTo(searchButton.snp.left).offset(-5)
            make.centerY.equalToSuperview()
            make.height.equalTo(36)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
