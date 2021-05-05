//
//  EditAccountViewController.swift
//  Pilican
//
//  Created by kairzhan on 3/11/21.
//

import UIKit
import RxSwift

class EditAccountViewController: ViewController, ViewHolder, EditAccountModule {
    var closeButton: CloseButton?
    
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
        let genderType = userInfoStorage.gender ?? true ? Gender.init(id: 1, gender: "Мужчина") : Gender.init(id: 0, gender: "Женщина")
        let output = viewModel.transform(
            input: .init(
                saveTapped: rootView.saveButton.rx.tap.asObservable(),
                username: Observable.merge(rootView.loginContainer.textField.rx.text.asObservable(), .just(userInfoStorage.mobilePhoneNumber)),
                fullname: Observable.merge(rootView.usernameContainer.textField.rx.text.asObservable(), .just(userInfoStorage.fullName)),
                city: Observable.merge(cityPickerDelegate.selectedCity.asObservable(), .just(City(id: userInfoStorage.cityId ?? 0, name: userInfoStorage.city ?? "" ))),
                gender: Observable.merge(genderPickerDelegate.selectedGender.asObservable(), .just(genderType)),
                birthday: Observable.merge( rootView.birthdayContainer.textField.rx.text.asObservable(), .just(userInfoStorage.birthday)),
                loadCity: rx.methodInvoked(#selector(viewWillAppear(_:))).map { _ in },
                loadGender: rx.methodInvoked(#selector(viewWillAppear(_:))).map { _ in }))

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
                    self.showAlert()
                }
            }).disposed(by: disposeBag)

        result.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)

        result.connect()
            .disposed(by: disposeBag)
    }

    private func showAlert() {
        let alert = UIAlertController(title: nil, message: "Данные успешно сохранились", preferredStyle: .alert)
        let action = UIAlertAction(title: "Закрыть", style: .default) { [unowned self] _ in
            self.userInfoStorage.mobilePhoneNumber = rootView.loginContainer.textField.text
            self.userInfoStorage.fullName = rootView.usernameContainer.textField.text
            self.userInfoStorage.city = rootView.cityContainer.textField.text
            self.userInfoStorage.gender = rootView.genderContainer.textField.text == "Мужчина" ? true : false
            self.userInfoStorage.birthday = rootView.birthdayContainer.textField.text
            self.userInfoStorage.updateInfo.onNext(())
            self.saveTapped?()
        }
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }

    override func customBackButtonDidTap() {
        closeButton?()
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
