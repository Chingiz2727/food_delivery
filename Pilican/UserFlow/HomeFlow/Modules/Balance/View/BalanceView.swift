//
//  BalanceView.swift
//  Pilican
//
//  Created by kairzhan on 3/17/21.
//

import UIKit

class BalanceView: UIView {
    
    let containerView = UIView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Пополнение Pillikan баланс"
        label.textColor = .pilicanBlack
        label.font = UIFont.semibold20
        label.textAlignment = .center
        return label
    }()
    
    private let enterBalanceTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = " Введите сумму пополнения"
        textField.font = UIFont.book16
        textField.textColor = .pilicanGray
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1
        textField.setLeftPaddingPoints(10)
        textField.setRightPaddingPoints(10)
        textField.keyboardType = .numberPad
        textField.layer.borderColor = UIColor.pilicanLightGray.cgColor
        return textField
    }()

    private let cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.balanceCard.image
        imageView.contentMode = .scaleToFill
        return imageView
    }()

    private let replishmentButton: UIButton = {
        let button = UIButton()
        button.setTitle("Пополнить", for: .normal)
        button.titleLabel?.font = UIFont.medium16
        button.setTitleColor(.pilicanWhite, for: .normal)
        button.backgroundColor = .primary
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.layer.addShadow()
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayouts() {
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(40)
            make.height.equalTo(227)
        }

        containerView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }

        containerView.addSubview(enterBalanceTextField)
        enterBalanceTextField.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(25)
            make.height.equalTo(37)
        }

        containerView.addSubview(cardImageView)
        cardImageView.snp.makeConstraints { (make) in
            make.top.equalTo(enterBalanceTextField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(89)
        }

        containerView.addSubview(replishmentButton)
        replishmentButton.snp.makeConstraints { (make) in
            make.top.equalTo(cardImageView.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(41)
            make.height.equalTo(40)
        }
    }

    private func configureView() {
        backgroundColor = .background
        containerView.backgroundColor = .pilicanWhite
        containerView.layer.cornerRadius = 10
    }
}
