//
//  OrderHistoryTableViewCell.swift
//  Pilican
//
//  Created by kairzhan on 4/17/21.
//
import RxSwift
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

    private let overallTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Всего"
        label.font = .semibold14
        label.textColor = .pilicanBlack
        return label
    }()

    private let overallValueLabel: UILabel = {
        let label = UILabel()
        label.text = "2222 kzt"
        label.font = .semibold16
        label.textColor = .primary
        return label
    }()

    private let repeatOrderButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("Заказать еще раз", for: .normal)
        button.setTitleColor(.pilicanWhite, for: .normal)
        button.layer.cornerRadius = 10
        return button
    }()

    private let dataView = UIView()
    private let bottomView = UIView()

    private lazy var stackView = UIStackView(
        views: [dataView, bottomView],
        axis: .vertical,
        spacing: 5)

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
        orderAmountLabel.text = "\(data.foodAmount ?? 0) тг"
        
        overallValueLabel.text = "\(data.foodAmount ?? 0) тг"
    }

    fileprivate func getFormatedDate(date_string: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru")
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        let dateFromInputString = dateFormatter.date(from: date_string)

        dateFormatter.dateFormat = "yyyy.MM.dd HH:mm"

        if dateFromInputString != nil {
           return dateFormatter.string(from: dateFromInputString!)
        } else {
            return "Сегодня"
        }
    }

    private func setupInitialLayouts() {
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(25)
        }

        dataView.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.height.equalTo(90)
            make.left.right.equalToSuperview().inset(10)
        }

        dataView.addSubview(orderNumberTitleLabel)
        orderNumberTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
        }

        dataView.addSubview(orderNumberLabel)
        orderNumberLabel.snp.makeConstraints { (make) in
            make.top.equalTo(orderNumberTitleLabel.snp.top)
            make.left.equalTo(orderNumberTitleLabel.snp.right).offset(3)
        }

        dataView.addSubview(orderDateLabel)
        orderDateLabel.snp.makeConstraints { (make) in
            make.top.equalTo(orderNumberTitleLabel.snp.top)
            make.right.equalToSuperview().inset(10)
        }

        dataView.addSubview(retailNameLabel)
        retailNameLabel.snp.makeConstraints { (make) in
            make.top.equalTo(orderNumberTitleLabel.snp.bottom).offset(8)
        }

        dataView.addSubview(orderAmountTitleLabel)
        orderAmountTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(retailNameLabel.snp.bottom).offset(8)
        }

        dataView.addSubview(orderAmountLabel)
        orderAmountLabel.snp.makeConstraints { (make) in
            make.top.equalTo(orderAmountTitleLabel.snp.top)
            make.left.equalTo(orderAmountTitleLabel.snp.right).offset(3)
        }

        dataView.addSubview(moreLabel)
        moreLabel.snp.makeConstraints { (make) in
            make.top.equalTo(orderAmountTitleLabel.snp.top)
            make.right.equalToSuperview().inset(10)
        }

        bottomView.snp.makeConstraints { (make) in
            make.height.equalTo(40)
        }

        bottomView.addSubview(overallValueLabel)
        overallValueLabel.snp.makeConstraints { (make) in
            make.bottom.equalToSuperview().inset(10)
        }

        bottomView.addSubview(repeatOrderButton)
        repeatOrderButton.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.height.equalTo(33)
            make.width.equalTo(160)
            make.right.equalToSuperview().inset(10)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        print(selected)
    }

    private func configureView() {
        stackView.backgroundColor = .pilicanWhite
        selectionStyle = .none
        stackView.layer.cornerRadius = 8
        backgroundColor = .background
    }
}
