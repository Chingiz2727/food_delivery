//
//  QRPaymentView.swift
//  Pilican
//
//  Created by kairzhan on 3/24/21.
//

import UIKit

class QRPaymentView: UIView {
    
    let retailView = RetailDetailHeaderView()
    
    let priceView = PriceView()

    let paymentChoiceView = PaymentChoiceView()

    let calculatePayView = CalculatePayView()

    let commentView = CommentForPartnerView()

    let payButton: UIButton = {
        let button = UIButton()
        button.setTitle("Оплатить", for: .normal)
        button.setTitleColor(.pilicanWhite, for: .normal)
        button.backgroundColor = .primary
        button.clipsToBounds = false
        button.layer.cornerRadius = 20
        button.layer.addShadow()
        return button
    }()
    
    private lazy var stackView = UIStackView(
        views:  [paymentChoiceView, calculatePayView],
        axis: .vertical,
        distribution: .equalSpacing,
        spacing: 5)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayouts() {
        addSubview(retailView)
        retailView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(50)
        }

        addSubview(priceView)
        priceView.snp.makeConstraints { (make) in
            make.top.equalTo(retailView.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(15)
        }

        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.top.equalTo(priceView.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(15)
        }

        addSubview(commentView)
        commentView.snp.makeConstraints { (make) in
            make.top.equalTo(stackView.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(15)
        }

        addSubview(payButton)
        payButton.snp.makeConstraints { (make) in
            make.top.equalTo(commentView.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
    }

    private func configureView() {
        backgroundColor = .background
        calculatePayView.isHidden = true
    }
}
