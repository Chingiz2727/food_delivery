//
//  AboutView.swift
//  Pilican
//
//  Created by kairzhan on 3/10/21.
//

import UIKit

class AboutView: UIView {
    
    let logoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = Images.pillikanLogo.image
        return imageView
    }()
    
    let sloganImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleToFill
        imageView.image = Images.sloganLogo.image
        return imageView
    }()

    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = " \nВремя работы Call - центра \nс 09:00 до 21:00 \nбез выходных"
        label.textAlignment = .center
        label.font = UIFont.semibold18
        label.textColor = .pilicanGray
        label.numberOfLines = 0
        return label
    }()

    let phoneButton: UIButton = {
        let button = UIButton()
        button.setTitle("+7(775)007-42-30", for: .normal)
        button.setTitleColor(.pilicanGray, for: .normal)
        button.layer.cornerRadius = 18
        button.clipsToBounds = false
        return button
    }()

    let instaButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = false
        button.setImage(Images.instagram.image, for: .normal)
        return button
    }()

    let youtubeButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = false
        button.setImage(Images.youtube.image, for: .normal)
        return button
    }()

    let webButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = false
        button.setImage(Images.web.image, for: .normal)
        return button
    }()

    let waButton: UIButton = {
        let button = UIButton()
        button.clipsToBounds = false
        button.setImage(Images.whatsapp.image, for: .normal)
        return button
    }()

    let termButton: UIButton = {
        let button = UIButton()
        button.setTitle(" Пользовательское соглашение и Политика конфиденциальности", for: .normal)
        button.setTitleColor(.pilicanLightGray, for: .normal)
        button.titleLabel?.font = UIFont.book14
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.numberOfLines = 0
        button.clipsToBounds = false
        return button
    }()

    let versionLabel: UILabel = {
        let label = UILabel()
        label.text = "Версия: 2.1.0"
        label.textAlignment = .center
        label.font = UIFont.book14
        label.textColor = .pilicanBlack
        return label
    }()

    let rateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Оценить приложения", for: .normal)
        button.setTitleColor(.pilicanWhite, for: .normal)
        button.titleLabel?.font = UIFont.book14
        button.backgroundColor = .primary
        button.clipsToBounds = true
        button.layer.cornerRadius = 12
        button.layer.addShadow()
        return button
    }()

    private lazy var logoStackView = UIStackView(
        views: [logoImageView, sloganImageView],
        axis: .vertical,
        distribution: .equalSpacing,
        alignment: .center,
        spacing: 10)

    private lazy var buttonStackView = UIStackView(
        views: [instaButton, youtubeButton, webButton, waButton],
        axis: .horizontal,
        distribution: .equalSpacing,
        spacing: 30)

    private lazy var mainStackView = UIStackView(
        views: [logoStackView, infoLabel, phoneButton, buttonStackView, termButton, versionLabel, rateButton],
        axis: .vertical,
        distribution: .fill,
        alignment: .center,
        spacing: 20)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(version: String) {
        versionLabel.text = "Версия: \(version)"
    }

    private func setupInitialLayouts() {
        backgroundColor = .background
        addSubview(mainStackView)
        mainStackView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(20)
            make.left.right.equalToSuperview().inset(40)
        }

        logoImageView.snp.makeConstraints { (make) in
            make.width.equalTo(36)
            make.height.equalTo(52)
        }

        sloganImageView.snp.makeConstraints { (make) in
            make.width.equalTo(144)
            make.height.equalTo(24)
        }

        rateButton.snp.makeConstraints { (make) in
            make.width.equalTo(360)
            make.height.equalTo(36)
        }
    }
}
