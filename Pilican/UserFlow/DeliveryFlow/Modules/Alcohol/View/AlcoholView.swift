//
//  AlcoholView.swift
//  Pilican
//
//  Created by kairzhan on 4/22/21.
//

import UIKit

class AlcoholView: UIView {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = Images.attentionAlcohol.image
        return imageView
    }()

    let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Внимание!"
        label.font = .semibold16
        return label
    }()

    let subTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Продолжая покупку данного товара, вы принимаете пункт 3.3.4. в пользовательском соглашении."
        label.numberOfLines = 0
        label.font = .book14
        label.textAlignment = .center
        return label
    }()

    let acceptButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .reciep
        button.setTitle("Принимаю", for: .normal)
        button.setTitleColor(.pilicanWhite, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()

    let dataView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
    }

    private func setupInitialLayouts() {
        addSubview(dataView)
        dataView.snp.makeConstraints { (make) in
            make.height.equalTo(339)
            make.width.equalTo(343)
            make.centerX.centerY.equalToSuperview()
        }

        dataView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(20)
            make.centerX.equalToSuperview()
        }

        dataView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageView.snp.bottom).offset(18)
            make.centerX.equalToSuperview()
        }

        dataView.addSubview(subTitleLabel)
        subTitleLabel.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.left.right.equalToSuperview().inset(43)
        }

        dataView.addSubview(acceptButton)
        acceptButton.snp.makeConstraints { (make) in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(23)
            make.left.right.equalToSuperview().inset(10)
            make.height.equalTo(45)
        }
        dataView.backgroundColor = .pilicanWhite
        dataView.layer.cornerRadius = 8
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
