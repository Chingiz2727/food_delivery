//
//  EditAccountView.swift
//  Pilican
//
//  Created by kairzhan on 3/11/21.
//

import UIKit

class EditAccountView: UIView {
    
    let loginContainer = TextFieldContainer<PhoneNumberTextField>()
    let usernameContainer = TextFieldContainer<TextField>()
    let cityContainer = TextFieldContainer<TextField>()
    let genderContainer = TextFieldContainer<TextField>()
    let birthdayContainer = TextFieldContainer<TextField>()

    lazy var datePicker: UIDatePicker = {
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        return datePicker
    }()

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
        views: [loginContainer, usernameContainer, cityContainer, genderContainer, birthdayContainer],
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
        birthdayContainer.textField.inputView = datePicker
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(userInfoStorage: UserInfoStorage) {
        loginContainer.textField.text = userInfoStorage.mobilePhoneNumber
        usernameContainer.textField.text = userInfoStorage.fullName
        cityContainer.textField.text = userInfoStorage.city
        genderContainer.textField.text = userInfoStorage.gender ?? true ? "Мужчина" : "Женщина"
        birthdayContainer.textField.text = userInfoStorage.birthday
    }

    private func setupInitialLayouts() {
        addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(15)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(470)
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
        usernameContainer.title = " Ф.И.О "
        cityContainer.title = " Город "
        genderContainer.title = " Пол "
        birthdayContainer.title = " Дата рождения "
        backgroundColor = .background
        containerView.backgroundColor = .pilicanWhite
        loginContainer.textField.isUserInteractionEnabled = false
        loginContainer.setTitleBackground(background: .pilicanWhite)
        usernameContainer.setTitleBackground(background: .pilicanWhite)
        usernameContainer.textField.normalBackgroundColor = .pilicanWhite
        usernameContainer.textField.selectedBackgroundColor = .pilicanWhite
        cityContainer.setTitleBackground(background: .pilicanWhite)
        cityContainer.textField.normalBackgroundColor = .pilicanWhite
        cityContainer.textField.selectedBackgroundColor = .pilicanWhite
        genderContainer.setTitleBackground(background: .pilicanWhite)
        genderContainer.textField.normalBackgroundColor = .pilicanWhite
        genderContainer.textField.selectedBackgroundColor = .pilicanWhite
        birthdayContainer.setTitleBackground(background: .pilicanWhite)
        birthdayContainer.textField.normalBackgroundColor = .pilicanWhite
        birthdayContainer.textField.selectedBackgroundColor = .pilicanWhite
    }
}
