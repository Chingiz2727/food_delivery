//
//  OrderItemsView.swift
//  Pilican
//
//  Created by kairzhan on 4/26/21.
//

import UIKit

class OrderItemsView: UITableViewCell {
    let productNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Ramen"
        label.textColor = .pilicanBlack
        label.font = .medium12
        return label
    }()

    let productCountLabel: UILabel = {
        let label = UILabel()
        label.text = "x 1"
        label.textColor = .pilicanBlack
        label.font = .medium12
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupInitialLayouts()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setData(data: OrderItems) {
        productNameLabel.text = data.dish?.name
        productCountLabel.text = "x \(data.quantity)"
    }
    private func setupInitialLayouts() {
        addSubview(productNameLabel)
        productNameLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.equalToSuperview()
        }

        addSubview(productCountLabel)
        productCountLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.right.equalToSuperview().inset(10)
        }
    }
}
