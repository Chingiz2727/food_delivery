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
        button.setImage(Images.correctCircle.image, for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    lazy var deleteCardButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(Images.quit.image?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.clipsToBounds = true
        return button
    }()
    
    private lazy var textStackView = UIStackView(
        views: [cardNameLabel, cardNumberLabel],
        axis: .vertical,
        spacing: 6)
    
    private lazy var buttonStackView = UIStackView(
        views: [choiceCheckButton, deleteCardButton],
        axis: .horizontal,
        distribution: .fillEqually,
        spacing: 6)
    
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
    
    func setupData(card: MyCard) {
        if card.isMain == 0 {
            self.choiceCheckButton.setImage(Images.correct.image?.withRenderingMode(.alwaysOriginal), for: .normal)
        } else {
            self.choiceCheckButton.setImage(Images.correctCircle.image?.withRenderingMode(.alwaysOriginal), for: .normal)
        }
        cardNameLabel.text = card.name
        cardNumberLabel.text = card.cardHash
    }
    
    private func setupInitialLayouts() {
        addSubview(dataView)
        dataView.snp.makeConstraints { (make) in
            make.left.right.bottom.top.equalToSuperview().inset(16)
        }
        
        dataView.addSubview(cardImageView)
        
        cardImageView.snp.makeConstraints { (make) in
            make.top.bottom.leading.equalToSuperview().inset(14)
        }
        
        dataView.addSubview(textStackView)
        
        textStackView.snp.makeConstraints { make in
            make.leading.equalTo(cardImageView.snp.trailing).offset(14)
            make.centerY.equalToSuperview()
        }
        
        dataView.addSubview(buttonStackView)
        buttonStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(14)
        }
    }
    
    
    private func configureView() {
        dataView.backgroundColor = .pilicanWhite
        dataView.layer.cornerRadius = 10
        backgroundColor = .clear
        selectionStyle = .none
    }
}
