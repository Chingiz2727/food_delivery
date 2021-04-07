//
//  OrderTypeTakeAway.swift
//  Pilican
//
//  Created by kairzhan on 4/7/21.
//

import UIKit

class OrderTypeTakeAway: UIView {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.takeAway.image
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Заберу навынос"
        label.font = UIFont.book18
        return label
    }()

    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "С собой через 15-20 мин."
        label.font = UIFont.book12
        label.textColor = .pilicanGray
        return label
    }()

    let rightButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.arrow.image, for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayouts() {
        addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().inset(28)
            make.centerY.equalToSuperview()
        }

        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(15)
            make.left.equalToSuperview().inset(81)
        }

        addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(5)
            make.left.equalTo(titleLabel.snp.left)
        }

        addSubview(rightButton)
        rightButton.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(22)
        }
    }
}
