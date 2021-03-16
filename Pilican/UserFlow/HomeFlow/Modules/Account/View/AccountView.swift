//
//  AccountView.swift
//  Pilican
//
//  Created by kairzhan on 3/1/21.
//

import UIKit

class AccountView: UIView {
    
    private let accountHeaderView = AccountHeaderView()
    private let accountCard = AccountCard()
    private let accountKey = AccountKey()
    let accountPassword = AccountPassword()
    private let accountQR = AccountQR()
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .equalSpacing
        stackView.spacing = 10
        return stackView
    }()
    private let existButton: UIButton = {
        let button = UIButton()
        button.setTitle("Выйти", for: .normal)
        button.backgroundColor = .orange
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.layer.addShadow()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.medium16
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInitialLayout() {
        addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).offset(12)
            make.height.equalTo(330)
        }

        stackView.addArrangedSubview(accountHeaderView)
        stackView.addArrangedSubview(accountCard)
        stackView.addArrangedSubview(accountKey)
        stackView.addArrangedSubview(accountPassword)
        stackView.addArrangedSubview(accountQR)
        
        addSubview(existButton)
        existButton.snp.makeConstraints { (make) in
            make.top.equalTo(stackView.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(50)
            make.height.equalTo(40)
        }
    }

    private func configureView() {
        backgroundColor = .grayBackground
    }
}
