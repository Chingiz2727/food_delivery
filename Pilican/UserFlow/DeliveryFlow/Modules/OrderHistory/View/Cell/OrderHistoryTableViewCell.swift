//
//  OrderHistoryTableViewCell.swift
//  Pilican
//
//  Created by kairzhan on 4/17/21.
//
import RxSwift
import UIKit

final class OrderHistoryTableViewCell: UITableViewCell {
    
    var onTryTap : ((Int) -> Void)?
    
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
        return label
    }()

    private let orderDateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .pilicanGray
        label.font = UIFont.medium8
        return label
    }()

    private let retailNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .pilicanBlack
        label.font = UIFont.medium12
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
        return label
    }()

    private let moreLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primary
        label.font = UIFont.medium12
        label.text = "Подробнее"
        return label
    }()

    private let totalTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .pilicanBlack
        label.font = UIFont.semibold16
        label.text = "Всего"
        return label
    }()
    
    private let totalAmountLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primary
        label.font = UIFont.semibold20
        return label
    }()
    
    let retryButton: PrimaryButton = {
        let button = PrimaryButton()
        return button
    }()
    
    
    private lazy var amountStackView = UIStackView(
        views: [totalTitleLabel,totalAmountLabel],
        axis: .vertical,
        distribution: .fill,
        spacing: 1)
    
    private lazy var retryStackView = UIStackView(
        views: [amountStackView, UIView(), retryButton],
        axis: .horizontal,
        distribution: .fillProportionally,
        spacing: 20)
    
    private let dataView = UIView()
    
    private lazy var infoStackView = UIStackView(
        views: [orderNumberTitleLabel, UIView(), orderNumberLabel],
        axis: .horizontal,
        spacing: 20)
    
    private lazy var moreStackView = UIStackView(
        views: [orderAmountTitleLabel,orderAmountLabel, UIView(), moreLabel],
        axis: .horizontal,
        spacing: 2)
    
    private lazy var fullStackView = UIStackView(
        views: [infoStackView,retailNameLabel, productStackView, moreStackView, retryStackView],
        axis: .vertical,
        distribution: .fill,
        spacing: 4)
    
    private lazy var productStackView = UIStackView(
        views: [],
        axis: .vertical,
        distribution: .fill,
        spacing: 3)
    
    var isExpanded = false {
        didSet {
            productStackView.isHidden = !isExpanded
            retryStackView.isHidden = !isExpanded
            moreStackView.isHidden = isExpanded
        }
    }
    
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
        orderDateLabel.text = getFormatedDate(date_string: data.createdAt ?? "")
        retailNameLabel.text = data.retailName
        orderAmountLabel.text = "\(data.foodAmount ?? 0) тг"
        if let data = data.orderItems {
            setupProduct(items: data)
        }
        retryButton.tag = data.status ?? 2
        let title = (data.status ?? 2) == 2 ? "Посмотреть статус" : "Заказать еще раз"
        retryButton.setTitle(title, for: .normal)
        totalAmountLabel.text = "\(data.fullAmount ?? 0) тг"
    }

    @objc private func retryTap(sender: UIButton) {
        self.onTryTap?(sender.tag)
    }
    
    private func setupProduct(items: [OrderItems]) {
        if productStackView.arrangedSubviews.count == 0 {
            items.forEach { [unowned self] item in
                let valueView = NameValueView()
                valueView.setup(name: item.dish?.name ?? "", value: "\(item.quantity ?? 0)х")
                self.productStackView.addArrangedSubview(valueView)
            }
        }
    }
    
    private func getFormatedDate(date_string: String) -> String {
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
        addSubview(dataView)
        dataView.snp.makeConstraints { $0.edges.equalToSuperview().inset(10) }
        dataView.addSubview(fullStackView)
        fullStackView.snp.makeConstraints { $0.edges.equalToSuperview().inset(10) }
        retryButton.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalTo(180)
        }
        retryButton.addTarget(self, action: #selector(retryTap(sender:)), for: .touchUpInside)
        retryButton.isUserInteractionEnabled = true
        retryButton.setContentHuggingPriority(.defaultLow, for: .horizontal)
    }
    
    private func configureView() {
        dataView.backgroundColor = .pilicanWhite
        selectionStyle = .none
        backgroundColor = .clear
        dataView.layer.cornerRadius = 8
        productStackView.isHidden = true
        retryStackView.isHidden = true
    }
}
