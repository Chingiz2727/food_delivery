//
//  OrderHistoryTableViewCell.swift
//  Pilican
//
//  Created by kairzhan on 4/17/21.
//

import UIKit

final class OrderHistoryTableViewCell: UITableViewCell {
    
    private let orderNumberTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .pilicanBlack
        label.font = UIFont.semibold16
        label.text = "Номер заказа:"
        return label
    }()
    
    private let orderNumberLabel: UILabel = {
        let label = UILabel()
        label.textColor = .pilicanBlack
        label.font = UIFont.semibold16
        label.text = "2143"
        return label
    }()
    
    private let orderDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .pilicanGray
        label.font = UIFont.medium8
        label.text = "10.11.2019 10:23"
        return label
    }()
    
    private let retailNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .pilicanBlack
        label.font = UIFont.medium12
        label.text = "Hali Gali"
        return label
    }()

    private let orderAmountTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .pilicanBlack
        label.font = UIFont.medium12
        label.text = "Сумма заказа:"
        return label
    }()
    
    private let orderAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .pilicanBlack
        label.font = UIFont.medium12
        label.text = "3848 тг"
        return label
    }()

    private let moreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primary
        label.font = UIFont.medium12
        label.text = "Подробнее"
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

    func setData(data: DeliveryOrderResponse) {
        orderNumberLabel.text = "\(data.id ?? 0)"
        orderDateLabel.text = getFormatedDate(date_string: data.createdAt)
        retailNameLabel.text = data.retailName
        orderAmountLabel.text = "\(data.foodAmount ?? 0)"
    }

    fileprivate func getFormatedDate(date_string: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        let dateFromInputString = dateFormatter.date(from: date_string)

        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"

        if (dateFromInputString != nil) {
           return dateFormatter.string(from: dateFromInputString!)
        } else {
            return "Сегодня"
        }
    }

    private func setupInitialLayouts() {
        addSubview(dataView)
        dataView.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(90)
        }

        dataView.addSubview(orderNumberTitleLabel)
        orderNumberTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(8)
        }

        dataView.addSubview(orderNumberLabel)
        orderNumberLabel.snp.makeConstraints { (make) in
            make.top.equalTo(orderNumberTitleLabel.snp.top)
            make.left.equalTo(orderNumberTitleLabel.snp.right).offset(3)
        }

        dataView.addSubview(orderDateLabel)
        orderDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(orderNumberTitleLabel.snp.top)
            make.right.equalToSuperview().inset(8)
        }

        dataView.addSubview(retailNameLabel)
        retailNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(orderNumberTitleLabel.snp.bottom).offset(8)
            make.left.equalTo(orderNumberTitleLabel.snp.left)
        }

        dataView.addSubview(orderAmountTitleLabel)
        orderAmountTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(retailNameLabel.snp.bottom).offset(8)
            make.left.equalTo(orderNumberTitleLabel.snp.left)
        }

        dataView.addSubview(orderAmountLabel)
        orderAmountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(orderAmountTitleLabel.snp.top)
            make.left.equalTo(orderAmountTitleLabel.snp.right).offset(3)
        }

        dataView.addSubview(moreLabel)
        moreLabel.snp.makeConstraints { (make) in
            make.top.equalTo(orderAmountTitleLabel.snp.top)
            make.right.equalToSuperview().inset(8)
        }
    }

    private func configureView() {
        dataView.backgroundColor = .pilicanWhite
        selectionStyle = .none
        dataView.layer.cornerRadius = 8
    }
}
