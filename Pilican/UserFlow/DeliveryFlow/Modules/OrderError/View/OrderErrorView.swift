//
//  OrderErrorView.swift
//  Pilican
//
//  Created by kairzhan on 4/22/21.
//

import UIKit

class OrderErrorView: UIView {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.orderError.image
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Что-то пошло не так"
        label.font = .semibold18
        return label
    }()

    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "К сожалению, ваш заказ не был оформлен \nпожалуйста, попробуйте еще раз"
        label.font = .book14
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    let repeatButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("Повторить", for: .normal)
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

        addSubview(repeatButton)
        repeatButton.snp.makeConstraints { (make) in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(45)
            make.left.right.equalToSuperview().inset(45)
            make.height.equalTo(40)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
