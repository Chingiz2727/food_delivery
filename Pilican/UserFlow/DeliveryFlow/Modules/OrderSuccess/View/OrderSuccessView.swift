//
//  OrderSuccessView.swift
//  Pilican
//
//  Created by kairzhan on 4/22/21.
//

import UIKit

class OrderSuccessView: UIView {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.orderSuccess.image
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ваш заказ оформлен"
        label.font = .semibold18
        return label
    }()

    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Ваш заказ обработан скоро \nкурьер доставить ваш заказ"
        label.font = .book14
        label.numberOfLines = 0
        return label
    }()

    let obserOrderButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("Отследить заказ", for: .normal)
        return button
    }()

    let toMainButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("На главную", for: .normal)
        button.backgroundColor = .pilicanLightGray
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
    }

    private func setupInitialLayouts() {
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(140)
            make.centerX.equalToSuperview()
        }

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(13)
            make.centerX.equalToSuperview()
        }

        addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(13)
            make.centerX.equalToSuperview()
        }

        addSubview(obserOrderButton)
        obserOrderButton.snp.makeConstraints { (make) in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(45)
            make.left.right.equalToSuperview().inset(45)
            make.height.equalTo(40)
        }

        addSubview(toMainButton)
        toMainButton.snp.makeConstraints { (make) in
            make.top.equalTo(obserOrderButton.snp.bottom).offset(12)
            make.left.right.equalToSuperview().inset(45)
            make.height.equalTo(40)
        }
        
        backgroundColor = .white
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
