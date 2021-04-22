//
//  ChangePasswordView.swift
//  Pilican
//
//  Created by kairzhan on 3/16/21.
//

import UIKit

class ChangePasswordView: UIView {
    
    let loginContainer = TextFieldContainer<PhoneNumberTextField>()
    let newPasswordContainer = TextFieldContainer<PasswordTextField>()
    let acceptPasswordContainer = TextFieldContainer<PasswordTextField>()

    let saveButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("Сохранить", for: .normal)
        return button
    }()

    private lazy var textFieldContainerStack = UIStackView(
        views: [loginContainer, newPasswordContainer, acceptPasswordContainer],
        axis: .vertical,
        distribution: .equalSpacing,
        spacing: 20)

    let containerView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        return view
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(login: String) {
        loginContainer.textField.text = login
    }

    private func setupInitialLayouts() {
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(15)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(339)
        }

        containerView.addSubview(textFieldContainerStack)
        textFieldContainerStack.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview().inset(16)
            make.top.equalToSuperview().offset(40)
        }
        containerView.addSubview(saveButton)
        saveButton.snp.makeConstraints { (make) in
            make.top.equalTo(textFieldContainerStack.snp.bottom).offset(30)
            make.centerX.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalTo(260)
        }
    }

    private func configureView() {
        loginContainer.title = " Логин "
        newPasswordContainer.title = " Пароль "
        acceptPasswordContainer.title = " Повторите пароль "
        backgroundColor = .background
        containerView.backgroundColor = .pilicanWhite
        loginContainer.textField.isUserInteractionEnabled = false
        loginContainer.setTitleBackground(background: .pilicanWhite)
        loginContainer.textField.normalBackgroundColor = .pilicanWhite
        loginContainer.textField.selectedBackgroundColor = .pilicanWhite
        newPasswordContainer.setTitleBackground(background: .pilicanWhite)
        newPasswordContainer.textField.normalBackgroundColor = .pilicanWhite
        newPasswordContainer.textField.selectedBackgroundColor = .pilicanWhite
        acceptPasswordContainer.setTitleBackground(background: .pilicanWhite)
        acceptPasswordContainer.textField.normalBackgroundColor = .pilicanWhite
        acceptPasswordContainer.textField.selectedBackgroundColor = .pilicanWhite
    }
}
