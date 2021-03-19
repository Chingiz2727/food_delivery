//
//  PayDetailView.swift
//  Pilican
//
//  Created by kairzhan on 3/18/21.
//

import UIKit

class PayDetailView: UIView {
    
    private let containerView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Квитанция"
        label.font = UIFont.semibold18
        label.backgroundColor = .reciep
        label.textAlignment = .center
        label.layer.cornerRadius = 8
        label.textColor = .white
        label.clipsToBounds = true
        return label
    }()

    private let amoutTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Сумма"
        label.textColor = .pilicanGray
        label.font = UIFont.book16
        label.textAlignment = .left
        return label
    }()

    private let reciepTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "№ квитанции"
        label.textColor = .pilicanGray
        label.font = UIFont.book16
        label.textAlignment = .left
        return label
    }()

    private let dateTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Дата"
        label.textColor = .pilicanGray
        label.font = UIFont.book16
        label.textAlignment = .left
        return label
    }()

    private let reciverTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Получатель"
        label.textColor = .pilicanGray
        label.font = UIFont.book16
        label.textAlignment = .left
        return label
    }()

    private let amoutValueLabel: UILabel = {
        let label = UILabel()
        label.text = "1000"
        label.textColor = .pilicanBlack
        label.font = UIFont.semibold18
        label.textAlignment = .right
        return label
    }()

    private let reciepValueLabel: UILabel = {
        let label = UILabel()
        label.text = "1234567"
        label.textColor = .pilicanBlack
        label.font = UIFont.semibold18
        label.textAlignment = .right
        return label
    }()

    private let dateValueLabel: UILabel = {
        let label = UILabel()
        label.text = "22/06/2020"
        label.textColor = .pilicanBlack
        label.font = UIFont.semibold18
        label.textAlignment = .right
        return label
    }()
    
    private let reciverValueLabel: UILabel = {
        let label = UILabel()
        label.text = "Moloko"
        label.textColor = .pilicanBlack
        label.font = UIFont.semibold18
        label.textAlignment = .right
        label.numberOfLines = 0
        return label
    }()

    lazy var amountStackView = UIStackView(
        views: [amoutTitleLabel, amoutValueLabel],
        axis: .horizontal,
        distribution: .fillEqually,
        alignment: .center, spacing: 1)

    lazy var reciepStackView = UIStackView(
        views: [reciepTitleLabel, reciepValueLabel],
        axis: .horizontal,
        distribution: .fillEqually,
        alignment: .center, spacing: 1)

    lazy var dateStackView = UIStackView(
        views: [dateTitleLabel, dateValueLabel],
        axis: .horizontal,
        distribution: .fillEqually,
        alignment: .center, spacing: 1)

    lazy var reciverStackView = UIStackView(
        views: [reciverTitleLabel, reciverValueLabel],
        axis: .horizontal,
        distribution: .fillEqually,
        alignment: .center, spacing: 1)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(data: Payments) {
        amoutValueLabel.text = "\(data.amount) kzt"
        reciepValueLabel.text = "\(data.id)"
        dateValueLabel.text = "\(data.updatedAt)"
        reciverValueLabel.text = data.retail?.name
    }

    private func setupInitialLayouts() {
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.height.equalTo(300)
            make.left.right.equalToSuperview().inset(10)
        }

        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(40)
        }

        containerView.addSubview(amountStackView)
        amountStackView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(16)
        }

        containerView.addSubview(reciepStackView)
        reciepStackView.snp.makeConstraints { (make) in
            make.top.equalTo(amountStackView.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(16)
        }

        containerView.addSubview(dateStackView)
        dateStackView.snp.makeConstraints { (make) in
            make.top.equalTo(reciepStackView.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(16)
        }

        containerView.addSubview(reciverStackView)
        reciverStackView.snp.makeConstraints { (make) in
            make.top.equalTo(dateStackView.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(16)
        }
    }

    private func configureView() {
        containerView.backgroundColor = .pilicanWhite
        containerView.layer.cornerRadius = 8
    }
}
