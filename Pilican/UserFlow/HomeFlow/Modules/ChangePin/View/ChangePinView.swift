//
//  ChangePinView.swift
//  Pilican
//
//  Created by kairzhan on 3/15/21.
//

import UIKit

class ChangePinView: UIView, UITextFieldDelegate {
    
    let passwordContainer = TextFieldContainer<PasswordTextField>()
    let newPinContainer = TextFieldContainer<PasswordTextField>()
    let acceptPinContainer = TextFieldContainer<PasswordTextField>()

    let saveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Сохранить", for: .normal)
        button.backgroundColor = .primary
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.layer.addShadow()
        button.setTitleColor(.pilicanWhite, for: .normal)
        button.titleLabel?.font = UIFont.medium21
        return button
    }()

    private lazy var textFieldContainerStack = UIStackView(
        views: [passwordContainer, newPinContainer, acceptPinContainer],
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

    private func setupInitialLayouts() {
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(15)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(328)
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
        passwordContainer.title = " Пароль "
        newPinContainer.title = " Введите новый PIN код "
        acceptPinContainer.title = " Подтвердите PIN код "
        backgroundColor = .background
        containerView.backgroundColor = .pilicanWhite
        newPinContainer.textField.keyboardType = .numberPad
        acceptPinContainer.textField.keyboardType = .numberPad
        newPinContainer.textField.delegate = self
        acceptPinContainer.textField.delegate = self
        passwordContainer.setTitleBackground(background: .pilicanWhite)
        passwordContainer.textField.normalBackgroundColor = .pilicanWhite
        passwordContainer.textField.selectedBackgroundColor = .pilicanWhite
        newPinContainer.setTitleBackground(background: .pilicanWhite)
        newPinContainer.textField.normalBackgroundColor = .pilicanWhite
        newPinContainer.textField.selectedBackgroundColor = .pilicanWhite
        acceptPinContainer.setTitleBackground(background: .pilicanWhite)
        acceptPinContainer.textField.normalBackgroundColor = .pilicanWhite
        acceptPinContainer.textField.selectedBackgroundColor = .pilicanWhite
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var maxLength = 0
        if textField == newPinContainer.textField || textField == acceptPinContainer.textField {
            maxLength = 4
        }
        let currentString: NSString = textField.text! as NSString
        let newString: NSString = currentString.replacingCharacters(in: range, with: string) as NSString
        return newString.length <= maxLength
    }
}
