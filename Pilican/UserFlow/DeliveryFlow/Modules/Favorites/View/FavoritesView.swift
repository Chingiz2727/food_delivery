//
//  FavoritesView.swift
//  Pilican
//
//  Created by kairzhan on 4/16/21.
//

import UIKit

class FavoritesView: UIView {
    let tableView = UITableView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func setupInitialLayout() {
        addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalTo(safeAreaLayoutGuide) }
    }

    private func configureView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = .background
        backgroundColor = .background
        tableView.registerClassForCell(DeliveryRetailListTableViewCell.self)
    }
}
