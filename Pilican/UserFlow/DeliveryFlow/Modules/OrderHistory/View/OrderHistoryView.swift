//
//  OrderHistoryView.swift
//  Pilican
//
//  Created by kairzhan on 4/17/21.
//

import UIKit

class OrderHistoryView: UIView {
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayouts() {
        addSubview(tableView)
        tableView.snp.makeConstraints { (make) in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).inset(10)
        }
    }

    private func configureView() {
        tableView.backgroundColor = .background
        backgroundColor = .background
        tableView.separatorStyle = .none
    }
}
