//
//  PaymentChoiceView.swift
//  Pilican
//
//  Created by kairzhan on 3/24/21.
//

import UIKit

class PaymentChoiceView: UIView {
    
    private let payChoiceTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Потратить Баллы"
        label.font = .book16
        label.textColor = .pilicanGray
        label.textAlignment = .center
        return label
    }()
    
    private let containerView = UIView()

    private let payChoiceCashbackLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.book10
        return label
    }()

    let choiceSwitch: UISwitch = {
        let choiceSwitch = UISwitch()
        choiceSwitch.isOn = false
        choiceSwitch.onTintColor = .choiceOnTint
        choiceSwitch.thumbTintColor = .pilicanLightGray
        return choiceSwitch
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
        configureView()
    }

    func setData(cashback: String) {
        let attributedText = NSMutableAttributedString(string: "Накоплено", attributes: [NSMutableAttributedString.Key.foregroundColor: UIColor.pilicanBlack])
        // swiftlint:disable line_length
        attributedText.append(NSAttributedString(string: " \(cashback)", attributes: [NSMutableAttributedString.Key.foregroundColor: UIColor.primary, NSMutableAttributedString.Key.font: UIFont.semibold16!]))

        attributedText.append(NSAttributedString(string: " баллов", attributes: [NSMutableAttributedString.Key.foregroundColor: UIColor.pilicanBlack]))
        payChoiceCashbackLabel.attributedText = attributedText
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayouts() {
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.left.bottom.top.right.equalToSuperview()
            make.height.equalTo(57)
        }

        containerView.addSubview(payChoiceTitleLabel)
        payChoiceTitleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(15)
        }

        containerView.addSubview(payChoiceCashbackLabel)
        payChoiceCashbackLabel.snp.makeConstraints { (make) in
            make.top.equalTo(payChoiceTitleLabel.snp.bottom).offset(1)
            make.left.equalToSuperview().inset(15)
        }

        containerView.addSubview(choiceSwitch)
        choiceSwitch.snp.makeConstraints { (make) in
            make.right.equalToSuperview().inset(18)
            make.centerY.equalToSuperview()
        }
    }

    private func configureView() {
        containerView.backgroundColor = .pilicanWhite
        containerView.layer.cornerRadius = 8
    }
}
