//
//  EditAccountViewController.swift
//  Pilican
//
//  Created by kairzhan on 3/11/21.
//

import UIKit
import RxSwift

class EditAccountViewController: ViewController, ViewHolder, EditAccountModule {
    var saveTapped: SaveTapped?

    typealias RootViewType = EditAccountView

    private let disposeBag = DisposeBag()
    private var cityPickerDelegate: CityPickerViewDelegate
    private var cityPickerDataSource: CityPickerViewDataSource
    private var genderPickerDelegate: GenderPickerViewDelegate
    private var genderPickerDataSource: GenderPickerViewDataSource
    private let cityPickerView = UIPickerView()
    private let genderPickerView = UIPickerView()
    private let viewModel: EditAccountViewModel
    private let dateFormatter: DateFormatting
    private let userInfoStorage: UserInfoStorage

    init(viewModel: EditAccountViewModel, dateFormatter: DateFormatting, userInfoStorage: UserInfoStorage) {
        self.viewModel = viewModel
        self.cityPickerDelegate = CityPickerViewDelegate()
        self.cityPickerDataSource = CityPickerViewDataSource()
        self.genderPickerDelegate = GenderPickerViewDelegate()
        self.genderPickerDataSource = GenderPickerViewDataSource()
        self.dateFormatter = dateFormatter
        self.userInfoStorage = userInfoStorage
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = EditAccountView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupCityPickerView()
        setupGenderPickerView()
        bindViewModel()
    }

    private func bindViewModel() {
        let output = viewModel.transform(
            input: .init(
                saveTapped: rootView.saveButton.rx.tap.asObservable(),
                username: rootView.loginContainer.textField.rx.text.asObservable().debug(),
                fullname: rootView.usernameContainer.textField.rx.text.asObservable().debug(),
                city: cityPickerDelegate.selectedCity.asObservable().debug(),
                gender: genderPickerDelegate.selectedGender.asObservable().debug(),
                birthday: rootView.birthdayContainer.textField.rx.text.asObservable().debug(),
                loadCity: rx.methodInvoked(#selector(viewWillAppear(_:))).map { _ in }.debug(),
                loadGender: rx.methodInvoked(#selector(viewWillAppear(_:))).map { _ in }.debug()))

        let city = output.getCity.publish()

        rootView.datePicker.rx.date
            .subscribe(onNext: { [unowned self] date in
                let currentDate = dateFormatter.string(from: date, type: .birthday)
                rootView.birthdayContainer.textField.text = "\(currentDate ?? "")"
            }).disposed(by: disposeBag)

        city.subscribe(onNext: { [unowned self] city in
            self.cityPickerDataSource.city = city
            self.cityPickerDelegate.city = city
            self.cityPickerView.reloadAllComponents()
        }).disposed(by: disposeBag)

        cityPickerDelegate.selectedCity
            .subscribe(onNext: { [unowned self] city in
                rootView.cityContainer.textField.text = city.name
            }).disposed(by: disposeBag)

        city.connect()
            .disposed(by: disposeBag)

        let gender = output.getGender.publish()

        gender.subscribe(onNext: { [unowned self] gender in
            self.genderPickerDelegate.gender = gender
            self.genderPickerDataSource.gender = gender
            self.genderPickerView.reloadAllComponents()
        }).disposed(by: disposeBag)

        genderPickerDelegate.selectedGender
            .subscribe(onNext: { [unowned self] gender in
                rootView.genderContainer.textField.text = gender.gender
            }).disposed(by: disposeBag)

        gender.connect()
            .disposed(by: disposeBag)

        rootView.setData(userInfoStorage: userInfoStorage)
        let result = output.updatedAccount.publish()

        result.element
            .subscribe(onNext: { [unowned self]  result in
                if result.status == 200 {
                    userInfoStorage.mobilePhoneNumber = rootView.loginContainer.textField.text
                    userInfoStorage.fullName = rootView.usernameContainer.textField.text
                    userInfoStorage.city = rootView.cityContainer.textField.text
                    userInfoStorage.gender = rootView.genderContainer.textField.text == "Мужчина" ? true : false
                    userInfoStorage.birthday = rootView.birthdayContainer.textField.text
                    self.saveTapped?()
                    self.showSimpleAlert(title: "", message: "Данные успешно сохранились!")
                }
            }).disposed(by: disposeBag)

        result.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)

        result.connect()
            .disposed(by: disposeBag)
    }

    private func setupCityPickerView() {
        cityPickerView.delegate = cityPickerDelegate
        cityPickerView.dataSource = cityPickerDataSource
        rootView.cityContainer.textField.inputView = cityPickerView
    }

    private func setupGenderPickerView() {
        genderPickerView.delegate = genderPickerDelegate
        genderPickerView.dataSource = genderPickerDataSource
        rootView.genderContainer.textField.inputView = genderPickerView
    }
}
