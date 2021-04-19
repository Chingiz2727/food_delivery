//
//  AboutContactsView.swift
//  Pilican
//
//  Created by kairzhan on 4/13/21.
//

import UIKit

class AboutContactsView: UIView {
    let contactsLabel: UILabel = {
        let label = UILabel()
        label.text = "Контакты"
        label.font = .semibold20
        return label
    }()

    let infoLabel: UILabel = {
        let label = UILabel()
        label.text = "Если у вас есть аллергия или диетические ограничения, пожалуйста, свяжитесь с рестораном для более точной информации о блюдах"
        label.font = .book14
        label.textColor = .pilicanGray
        label.numberOfLines = 0
        return label
    }()

    let retailNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Ресторан"
        label.font = .book16
        label.textColor = .pilicanGray
        return label
    }()

    let retailPhoneButton: UIButton = {
        let button = UIButton()
        button.setTitle("+7 777 777 77 77", for: .normal)
        button.titleLabel?.font = .semibold16
        button.setTitleColor(.primary, for: .normal)
        return button
    }()

    lazy var retailStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [retailNameLabel, retailPhoneButton])
        stack.distribution = .equalSpacing
        stack.axis = .horizontal
        return stack
    }()

    let siteLabel: UILabel = {
        let label = UILabel()
        label.text = "Сайт"
        label.font = .book16
        label.textColor = .pilicanGray
        return label
    }()

    let siteLinkButton: UIButton = {
        let button = UIButton()
        button.setTitle("Открыть сайт", for: .normal)
        button.titleLabel?.font = .semibold16
        button.setTitleColor(.primary, for: .normal)
        return button
    }()

    lazy var siteStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [siteLabel, siteLinkButton])
        stack.distribution = .equalSpacing
        stack.axis = .horizontal
        return stack
    }()

    let supportLabel: UILabel = {
        let label = UILabel()
        label.text = "Служба поддержки Pillikan"
        label.font = .book16
        label.textColor = .pilicanGray
        return label
    }()

    let supportLinkButton: UIButton = {
        let button = UIButton()
        button.setTitle("Позвонить", for: .normal)
        button.titleLabel?.font = .semibold16
        button.setTitleColor(.primary, for: .normal)
        return button
    }()

    lazy var supportStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [supportLabel, supportLinkButton])
        stack.distribution = .equalSpacing
        stack.axis = .horizontal
        return stack
    }()

    let dividerLine = UIView()
    let secondDividerLine = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
        configureView()
    }
    
    func setupData(retail: Retail) {
        retailPhoneButton.setTitle(retail.phone, for: .normal)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayouts() {
        addSubview(contactsLabel)
        contactsLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(5)
            make.left.equalToSuperview()
        }

        addSubview(infoLabel)
        infoLabel.snp.makeConstraints { (make) in
            make.top.equalTo(contactsLabel.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
        }

        addSubview(retailStackView)
        retailStackView.snp.makeConstraints { (make) in
            make.top.equalTo(infoLabel.snp.bottom).offset(18)
            make.left.right.equalToSuperview()
        }

        addSubview(dividerLine)
        dividerLine.snp.makeConstraints { (make) in
            make.top.equalTo(retailStackView.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }

        addSubview(siteStackView)
        siteStackView.snp.makeConstraints { (make) in
            make.top.equalTo(dividerLine.snp.bottom).offset(7)
            make.left.right.equalToSuperview()
        }

        addSubview(secondDividerLine)
        secondDividerLine.snp.makeConstraints { (make) in
            make.top.equalTo(siteStackView.snp.bottom).offset(5)
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }

        addSubview(supportStackView)
        supportStackView.snp.makeConstraints { (make) in
            make.top.equalTo(secondDividerLine.snp.bottom).offset(7)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }

    private func configureView() {
        dividerLine.backgroundColor = .pilicanLightGray
        secondDividerLine.backgroundColor = .pilicanLightGray
    }
}
