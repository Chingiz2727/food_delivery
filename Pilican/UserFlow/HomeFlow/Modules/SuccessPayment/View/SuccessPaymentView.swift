//
//  SuccessPaymentView.swift
//  Pilican
//
//  Created by kairzhan on 3/29/21.
//

import UIKit
import Lottie

class SuccessPaymentView: UIView {

    let retailView = RetailDetailHeaderView()

    let contentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.successPaymentBackground.image
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()

    let checkedSuccesView = AnimationView()

    let paymentStatusLabel: UILabel = {
        let label = UILabel()
        label.text = "Вы оплатили"
        label.font = .book16
        label.textColor = .pilicanGray
        label.textAlignment = .center
        return label
    }()

    let paymentPriceLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.semibold24
        label.text = "1000"
        label.textColor = .pilicanBlack
        label.textAlignment = .center
        return label
    }()

    let paymentCashbackLabel: UILabel = {
        let label = UILabel()
        label.text = "23 cashback"
        label.font = UIFont.semibold16
        label.textColor = .primary
        label.textAlignment = .center
        return label
    }()

    let nextButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("Продолжить", for: .normal)
        button.layer.addShadow()
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
        configureView()
        setAnimation()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(price: String, cashback: String) {
        paymentPriceLabel.text = "\(price) kzt."
        paymentCashbackLabel.text = "кэшбэк +\(cashback)"
    }

    private func setAnimation() {
        checkedSuccesView.animation = Animation.named("success-animation")
        checkedSuccesView.contentMode = .scaleAspectFit
        checkedSuccesView.loopMode = .playOnce
        checkedSuccesView.play()
    }

    private func setupInitialLayouts() {
        addSubview(contentImageView)
        contentImageView.snp.makeConstraints { (make) in
            make.left.top.bottom.right.equalToSuperview()
        }

        addSubview(checkedSuccesView)
        checkedSuccesView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(80)
            make.size.equalTo(200)
            make.centerX.equalToSuperview()
        }

        addSubview(paymentStatusLabel)
        paymentStatusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(checkedSuccesView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }

        addSubview(paymentPriceLabel)
        paymentPriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(paymentStatusLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        addSubview(paymentCashbackLabel)
        paymentCashbackLabel.snp.makeConstraints { (make) in
            make.top.equalTo(paymentPriceLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }

        addSubview(retailView)
        retailView.snp.makeConstraints { (make) in
            make.top.equalTo(paymentCashbackLabel.snp.bottom).offset(100)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(100)
        }

        addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.top.equalTo(retailView.snp.bottom).offset(50)
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(40)
        }
    }

    private func configureView() {
    }
}
