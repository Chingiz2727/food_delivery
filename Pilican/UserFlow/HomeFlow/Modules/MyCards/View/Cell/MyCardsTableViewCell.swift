//
//  MyCardsTableViewCell.swift
//  Pilican
//
//  Created by kairzhan on 3/16/21.
//

import UIKit

final class MyCardsTableViewCell: UITableViewCell {
    
    private let cardImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.card.image
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 24
        return imageView
    }()

    private let cardNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Kaspi"
        label.font = UIFont.semibold16
        label.textAlignment = .left
        label.textColor = .pilicanBlack
        return label
    }()

    private let cardNumberLabel: UILabel = {
        let label = UILabel()
        label.text = "6123 12XX XXXX XX53"
        label.font = UIFont.semibold16
        label.textAlignment = .left
        label.textColor = .pilicanLightGray
        return label
    }()

    lazy var choiceCheckButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.selectedCardButton.image, for: .normal)
        button.clipsToBounds = true
        return button
    }()

    lazy var deleteCardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Images.deleteCardButton.image, for: .normal)
        button.clipsToBounds = true
        return button
    }()

    private let dataView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupInitialLayouts()
        configureView()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        dataView.layer.cornerRadius = 10
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayouts() {
        addSubview(dataView)
        dataView.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview()
        }

        dataView.addSubview(cardImageView)
        cardImageView.snp.makeConstraints { (make) in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(16)
        }

        dataView.addSubview(cardNameLabel)
        cardNameLabel.snp.makeConstraints { (make) in
            make.left.equalTo(cardImageView.snp.right).offset(14)
            make.top.equalToSuperview().inset(19)
        }

        dataView.addSubview(cardNumberLabel)
        cardNumberLabel.snp.makeConstraints { (make) in
            make.left.equalTo(cardNameLabel.snp.left)
            make.top.equalTo(cardNameLabel.snp.bottom).offset(6)
        }

        dataView.addSubview(deleteCardButton)
        deleteCardButton.snp.makeConstraints { (make) in
            make.top.right.equalToSuperview().inset(27)
            make.height.width.equalTo(20)
        }

        dataView.addSubview(choiceCheckButton)
        choiceCheckButton.snp.makeConstraints { (make) in
            make.top.equalTo(deleteCardButton.snp.top)
            make.right.equalTo(deleteCardButton.snp.left).offset(10)
            make.height.width.equalTo(20)
        }
    }

    private func configureView() {
        dataView.backgroundColor = .pilicanWhite
    }
}
