//
//  SuccessPaymentView.swift
//  Pilican
//
//  Created by kairzhan on 3/29/21.
//

import UIKit
import Lottie

class SuccessPaymentView: UIView {
    let scrollView = UIScrollView()
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
        label.font = UIFont.semibold24
        label.textColor = .primary
        label.textAlignment = .center
        return label
    }()

    let bonusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.newBonusPrimary.image
        imageView.contentMode = .scaleAspectFit
        return imageView
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
        scrollView.alwaysBounceVertical = true
        scrollView.bounces = false
    }

    private lazy var bonusStack = UIStackView(
        views: [paymentCashbackLabel, bonusImageView],
        axis: .horizontal,
        distribution: .fill,
        spacing: 5)
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(price: String, cashback: String) {
        paymentPriceLabel.text = "\(price) 〒"
        
        paymentCashbackLabel.text = "+ \(cashback)"
        paymentCashbackLabel.isHidden = cashback == "0"
    }

    private func setAnimation() {
        checkedSuccesView.animation = Animation.named("success-animation")
        checkedSuccesView.contentMode = .scaleAspectFit
        checkedSuccesView.loopMode = .playOnce
        checkedSuccesView.play()
    }

    private func setupInitialLayouts() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { $0.edges.width.height.equalToSuperview()
        }

        scrollView.addSubview(contentImageView)
        contentImageView.snp.makeConstraints { (make) in
            make.edges.width.height.equalToSuperview()
        }

        scrollView.addSubview(checkedSuccesView)
        checkedSuccesView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(20)
            make.size.equalTo(200)
            make.centerX.equalToSuperview()
        }

        scrollView.addSubview(paymentStatusLabel)
        paymentStatusLabel.snp.makeConstraints { (make) in
            make.top.equalTo(checkedSuccesView.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
        }

        scrollView.addSubview(paymentPriceLabel)
        paymentPriceLabel.snp.makeConstraints { (make) in
            make.top.equalTo(paymentStatusLabel.snp.bottom).offset(10)
            make.centerX.equalToSuperview()
        }
        
        scrollView.addSubview(bonusStack)
        
        bonusStack.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(paymentPriceLabel.snp.bottom).offset(10)
        }
        bonusImageView.snp.makeConstraints { $0.width.equalTo(15) }
        scrollView.addSubview(nextButton)
        nextButton.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(50)
            make.height.equalTo(40)
        }

        scrollView.addSubview(retailView)
        retailView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(16)
            make.bottom.equalTo(nextButton.snp.top).offset(-20)
            make.height.equalTo(100)
        }
        backgroundColor = .white
    }

    private func configureView() {
    }
}
