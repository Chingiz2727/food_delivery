//
//  AboutDeliveryView.swift
//  Pilican
//
//  Created by kairzhan on 4/13/21.
//

import UIKit

class AboutDeliveryView: UIView {
    let aboutDeliveryLabel: UILabel = {
        let label = UILabel()
        label.text = "Информация о доставке"
        label.font = .semibold20
        return label
    }()

    let deliveryPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "Стоимость доставки"
        label.font = .book16
        label.textColor = .pilicanGray
        return label
    }()

    let deliveryPriceValueLabel: UILabel = {
        let label = UILabel()
        label.text = "600 kzt"
        label.font = .book16
        label.textColor = .pilicanGray
        return label
    }()

    lazy var deliveryPriceStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [deliveryPriceLabel, deliveryPriceValueLabel])
        stack.distribution = .equalSpacing
        stack.axis = .horizontal
        return stack
    }()

    let distanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Стоимость заказа"
        label.font = .book16
        label.textColor = .pilicanGray
        return label
    }()

    let distanceValueLabel: UILabel = {
        let label = UILabel()
        label.text = "1600 〒"
        label.font = .book16
        label.textColor = .pilicanGray
        return label
    }()

    lazy var distanceStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [distanceLabel, distanceValueLabel])
        stack.distribution = .equalSpacing
        stack.axis = .horizontal
        return stack
    }()

    let minPriceLabel: UILabel = {
        let label = UILabel()
        label.text = "Общая стоимость"
        label.font = .book16
        label.textColor = .pilicanGray
        return label
    }()

    let minPriceValueLabel: UILabel = {
        let label = UILabel()
        label.text = "2 500 kzt"
        label.font = .book16
        label.textColor = .pilicanGray
        return label
    }()

    lazy var minPriceStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [minPriceLabel, minPriceValueLabel])
        stack.distribution = .equalSpacing
        stack.axis = .horizontal
        return stack
    }()

    let timeLabel: UILabel = {
        let label = UILabel()
        label.text = "Примерное время доставки"
        label.font = .book16
        label.textColor = .pilicanGray
        return label
    }()

    let timeValueLabel: UILabel = {
        let label = UILabel()
        label.text = "50-60 мин."
        label.font = .book16
        label.textColor = .pilicanGray
        return label
    }()

    lazy var timeStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [timeLabel, timeValueLabel])
        stack.distribution = .equalSpacing
        stack.axis = .horizontal
        return stack
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
    }

    func setupData() {
        
    }

    private func setupInitialLayouts() {
        addSubview(aboutDeliveryLabel)
        aboutDeliveryLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(5)
            make.left.equalToSuperview()
        }

        addSubview(deliveryPriceStackView)
        deliveryPriceStackView.snp.makeConstraints { (make) in
            make.top.equalTo(aboutDeliveryLabel.snp.bottom).offset(12)
            make.left.right.equalToSuperview()
        }

        addSubview(distanceStackView)
        distanceStackView.snp.makeConstraints { (make) in
            make.top.equalTo(deliveryPriceStackView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
        }

        addSubview(minPriceStackView)
        minPriceStackView.snp.makeConstraints { (make) in
            make.top.equalTo(distanceStackView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
        }

        addSubview(timeStackView)
        timeStackView.snp.makeConstraints { (make) in
            make.top.equalTo(minPriceStackView.snp.bottom).offset(8)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
