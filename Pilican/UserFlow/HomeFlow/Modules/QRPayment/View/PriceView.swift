//
//  PriceView.swift
//  Pilican
//
//  Created by kairzhan on 3/24/21.
//

import UIKit

class PriceView: UIView {
    
    private let containerView = UIView()
    
    let priceTextField: LimitedLengthField = {
        let textField = LimitedLengthField()
        textField.placeholder = "Введите сумму оплаты"
        textField.font = .medium16
        textField.keyboardType = .numberPad
        return textField
    }()

    private let cashbackView = UIView()

    private let cashbackValueLabel: UILabel = {
        let label = UILabel()
        label.text = "200"
        label.font = .medium16
        label.textColor = .pilicanWhite
        label.textAlignment = .center
        return label
    }()

    private let cashbackTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Бонусы"
        label.font = .book9
        label.textColor = .pilicanWhite
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
        configureView()
    }

    func setData(cashback: String) {
        cashbackValueLabel.text = cashback
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayouts() {
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.left.top.right.bottom.equalToSuperview()
            make.height.equalTo(57)
        }

        containerView.addSubview(priceTextField)
        priceTextField.snp.makeConstraints { (make) in
            make.top.leading.equalToSuperview().inset(17)
            make.trailing.equalToSuperview()
        }

        containerView.addSubview(cashbackView)
        cashbackView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.right.equalToSuperview().inset(16)
            make.height.equalTo(37)
            make.width.equalTo(64)
        }

        cashbackView.addSubview(cashbackValueLabel)
        cashbackValueLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(3)
            make.centerX.equalToSuperview()
        }

        cashbackView.addSubview(cashbackTitleLabel)
        cashbackTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(cashbackValueLabel.snp.bottom).offset(-3)
            make.centerX.equalToSuperview()
        }
    }

    private func configureView() {
        containerView.backgroundColor = .pilicanWhite
        containerView.layer.cornerRadius = 8

        cashbackView.backgroundColor = .primary
        cashbackView.layer.cornerRadius = 6
    }
}

class LimitedLengthField: UITextField {
    var maxLength: Int = 7
    override func willMove(toSuperview newSuperview: UIView?) {
        addTarget(self, action: #selector(editingChanged), for: .editingChanged)
        editingChanged()
    }
    @objc func editingChanged() {
        text = String(text!.prefix(maxLength))
    }
}
