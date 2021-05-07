//
//  CalculatePayView.swift
//  Pilican
//
//  Created by kairzhan on 3/24/21.
//

import UIKit

class CalculatePayView: UIView {

    private let containerView = UIView()

    private let caluculateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Будет списано:"
        label.font = .book12
        label.textColor = .pilicanGray
        label.textAlignment = .center
        return label
    }()

    private let fromCardValueLabel: UILabel = {
        let label = UILabel()
        label.text = "820"
        label.font = .book12
        label.textColor = .pilicanGray
        label.backgroundColor = .pilicanWhite
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        return label
    }()

    private let fromCashbackValueLabel: UILabel = {
        let label = UILabel()
        label.text = "257"
        label.font = .book12
        label.textColor = .pilicanWhite
        label.backgroundColor = .primary
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.layer.masksToBounds = true
        return label
    }()

    private let fromCardTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "с карты"
        label.font = .book10
        label.textColor = .pilicanLightGray
        label.textAlignment = .center
        return label
    }()

    private let fromCashbackTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "с бонусов"
        label.font = .book10
        label.textColor = .pilicanLightGray
        label.textAlignment = .center
        return label
    }()

    private let plusLabel: UILabel = {
        let label = UILabel()
        label.text = "+"
        label.font = .book10
        label.textColor = .pilicanLightGray
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
        configureView()
    }

    func setData(cardValue: String, cashbackValue: String) {
        fromCardValueLabel.text = cardValue
        fromCashbackValueLabel.text = cashbackValue
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayouts() {
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
            make.height.equalTo(60)
        }

        containerView.addSubview(caluculateTitleLabel)
        caluculateTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
        }

        containerView.addSubview(plusLabel)
        plusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(caluculateTitleLabel.snp.bottom).offset(16)
            make.centerX.equalToSuperview()
        }

        containerView.addSubview(fromCardValueLabel)
        fromCardValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(caluculateTitleLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview().offset(-40)
            make.height.equalTo(18)
            make.width.equalTo(60)
        }

        containerView.addSubview(fromCardTitleLabel)
        fromCardTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(fromCardValueLabel.snp.bottom).offset(1)
            make.centerX.equalTo(fromCardValueLabel.snp.centerX)
        }

        containerView.addSubview(fromCashbackValueLabel)
        fromCashbackValueLabel.snp.makeConstraints { (make) in
            make.top.equalTo(caluculateTitleLabel.snp.bottom).offset(5)
            make.centerX.equalToSuperview().offset(40)
            make.height.equalTo(18)
            make.width.equalTo(60)
        }

        containerView.addSubview(fromCashbackTitleLabel)
        fromCashbackTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(fromCashbackValueLabel.snp.bottom).offset(1)
            make.centerX.equalTo(fromCashbackValueLabel.snp.centerX)
        }
    }

    private func configureView() {
    }
}
