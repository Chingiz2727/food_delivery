//
//  OrderTypeView.swift
//  Pilican
//
//  Created by kairzhan on 4/7/21.
//

import UIKit

class OrderTypeView: UIView {

    let tableView = UITableView()
    let headerView = OrderTypeHeaderView()
    private let emptyTitleLabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setup(product: [Product]) {
        tableView.isHidden = product.isEmpty
        emptyTitleLabel.isHidden = !product.isEmpty
    }
    
    private func setupInitialLayouts() {
        addSubview(tableView)
        addSubview(emptyTitleLabel)
        emptyTitleLabel.snp.makeConstraints { $0.center.equalToSuperview() }
        
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        headerView.snp.makeConstraints { $0.height.equalTo(240) }
        tableView.registerClassForCell(OrderTypeTableViewCell.self)
        tableView.tableFooterView = UIView()

    }
    
    private func configureView() {
        emptyTitleLabel.font = .medium24
        tableView.bounces = false
        tableView.tableHeaderView = headerView
        emptyTitleLabel.text = "Ваша корзина пуста"
        emptyTitleLabel.isHidden = true
    }
    
}
