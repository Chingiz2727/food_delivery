//
//  BonusView.swift
//  Pilican
//
//  Created by kairzhan on 3/10/21.
//

import UIKit

class BonusView: UIView {
    
    let bonusImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        imageView.image = Images.volunteer.image
        imageView.layer.zPosition = 1
        return imageView
    }()
    
    let bonusView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.layer.addShadow()
        return view
    }()

    let bonusTitleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.semibold20
        label.text = "\"Pillikan\" дарит бонусные баллы \nВам и Вашим друзьям"
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()

    let promoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.book12
        label.text = "Ваш личный промокод"
        label.textColor = .pilicanLightGray
        return label
    }()

    let codeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.semibold18
        label.text = "VOL-3NBV"
        label.textColor = .primary
        label.textAlignment = .center
        label.layer.borderColor = UIColor.pilicanLightGray.cgColor
        label.layer.borderWidth = 1
        label.layer.cornerRadius = 8
        return label
    }()

    let copyButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.copyButton.image, for: .normal)
        return button
    }()

    let qrImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.clipsToBounds = true
        return imageView
    }()

    let infoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.semibold20
        label.text = "Пригласи друга - получи бонусы"
        label.numberOfLines = 0
        return label
    }()

    let infoButton: UIButton = {
        let button = UIButton()
        button.setTitle("Подробнее...", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = UIFont.semibold16
        return button
    }()

    let shareButton: UIButton = {
        let button = UIButton()
        button.setTitle("Поделиться", for: .normal)
        button.backgroundColor = .systemOrange
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.layer.addShadow()
        button.setTitleColor(.pilicanWhite, for: .normal)
        button.titleLabel?.font = UIFont.book16
        return button
    }()

    private lazy var stackView = UIStackView(
        views: [bonusTitleLabel, promoLabel, codeLabel, qrImageView, infoLabel, infoButton, shareButton],
        axis: .vertical,
        distribution: .equalSpacing, alignment: .center, spacing: 2)

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setupInitialLayouts()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(promo: String, image: UIImage) {
        codeLabel.text = promo
        qrImageView.image = image
    }

    private func setupInitialLayouts() {
        addSubview(bonusImageView)
        bonusImageView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(20)
            make.centerX.equalToSuperview()
        }

        addSubview(bonusView)
        bonusView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(80)
            make.height.equalTo(400)
            make.left.right.equalToSuperview().inset(16)
        }

        bonusView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(80)
            make.bottom.equalToSuperview().inset(-20)
        }

        codeLabel.snp.makeConstraints { (make) in
            make.width.equalTo(260)
            make.height.equalTo(37)
        }

        shareButton.snp.makeConstraints { (make) in
            make.height.equalTo(40)
            make.width.equalTo(260)
        }

        qrImageView.snp.makeConstraints { (make) in
            make.height.width.equalTo(120)
        }

        bonusView.addSubview(copyButton)
        copyButton.snp.makeConstraints { (make) in
            make.top.equalTo(codeLabel.snp.top).offset(10)
            make.right.equalTo(codeLabel.snp.right).inset(10)
        }
    }

    private func configureView() {
        backgroundColor = .background
        bonusView.backgroundColor = .pilicanWhite
    }
}
