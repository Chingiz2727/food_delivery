//
//  PayHistoryTableViewCell.swift
//  Pilican
//
//  Created by kairzhan on 3/17/21.
//

import UIKit

final class PayHistoryTableViewCell: UITableViewCell {

    private let retailNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .pilicanBlack
        label.font = UIFont.semibold16
        label.text = "Kaira"
        return label
    }()

    private let payInfoLabel: UILabel = {
        let label = UILabel()
        label.textColor = .pilicanBlack
        label.font = UIFont.book10
        label.text = "С карты - 1 100тг, 130 бонусов"
        return label
    }()

    private let payDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .pilicanGray
        label.font = UIFont.medium8
        label.text = "10.11.2019 10:23"
        return label
    }()

    private let payAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .pilicanBlack
        label.font = UIFont.semibold14
        label.text = "1 200 〒"
        return label
    }()

    private let dataView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupInitialLayouts()
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(data: Payments) {
        retailNameLabel.text = data.retail?.name
        payInfoLabel.text = "Кэшбэк \(data.cbAmount)"
        payAmountLabel.text = "\(data.amount) kzt"
        payDateLabel.text = data.updatedAt
    }

    private func setupInitialLayouts() {
        addSubview(dataView)
        dataView.snp.makeConstraints { (make) in
            make.left.right.top.bottom.equalToSuperview()
            make.height.equalTo(74)
        }

        dataView.addSubview(retailNameLabel)
        retailNameLabel.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview().inset(16)
        }

        dataView.addSubview(payInfoLabel)
        payInfoLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(retailNameLabel.snp.bottom).offset(1)
        }

        dataView.addSubview(payDateLabel)
        payDateLabel.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(16)
            make.top.equalTo(payInfoLabel.snp.bottom).offset(2)
        }

        dataView.addSubview(payAmountLabel)
        payAmountLabel.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }

    private func configureView() {
        dataView.backgroundColor = .pilicanWhite
        selectionStyle = .none
    }
}
