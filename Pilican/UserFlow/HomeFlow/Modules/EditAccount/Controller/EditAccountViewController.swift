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
    private let cache = DiskCache<String, Any>()

    init(viewModel: EditAccountViewModel, dateFormatter: DateFormatting) {
        self.viewModel = viewModel
        self.cityPickerDelegate = CityPickerViewDelegate()
        self.cityPickerDataSource = CityPickerViewDataSource()
        self.genderPickerDelegate = GenderPickerViewDelegate()
        self.genderPickerDataSource = GenderPickerViewDataSource()
        self.dateFormatter = dateFormatter
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
        bindViewModel()
        setupCityPickerView()
        setupGenderPickerView()
    }

    private func bindViewModel() {
        let input = EditAccountViewModel.Input(
            saveTapped: rootView.saveButton.rx.tap.asObservable(),
            username: rootView.loginContainer.textField.phoneText.asObservable(),
            fullname: rootView.usernameContainer.textField.rx.text.asObservable(),
            city: cityPickerDelegate.selectedCity.asObservable(),
            gender: genderPickerDelegate.selectedGender.asObservable(),
            birthday: rootView.birthdayContainer.textField.rx.text.asObservable(),
            loadCity: rx.methodInvoked(#selector(viewWillAppear(_:))).map { _ in
            },
            loadGender: rx.methodInvoked(#selector(viewWillAppear(_:))).map { _ in
            })
        let output = viewModel.transform(input: input)

        let city = output.getCity.publish()

        rootView.datePicker.rx.date
            .subscribe(onNext: { [unowned self] date in
                let currentDate = dateFormatter.string(from: date, type: .birthday)
                rootView.birthdayContainer.textField.text = "\(currentDate ?? "")"
            })
            .disposed(by: disposeBag)

        city.subscribe(onNext: { [unowned self] city in
            self.cityPickerDataSource.city = city
            self.cityPickerDelegate.city = city
            self.cityPickerView.reloadAllComponents()
        })
        .disposed(by: disposeBag)

        cityPickerDelegate.selectedCity
            .subscribe(onNext: { [unowned self] city in
                rootView.cityContainer.textField.text = city.name
            })
            .disposed(by: disposeBag)

        city.connect()
            .disposed(by: disposeBag)

        let gender = output.getGender.publish()

        gender.subscribe(onNext: { [unowned self] gender in
            self.genderPickerDelegate.gender = gender
            self.genderPickerDataSource.gender = gender
            self.genderPickerView.reloadAllComponents()
        })
        .disposed(by: disposeBag)

        genderPickerDelegate.selectedGender
            .subscribe(onNext: { [unowned self] gender in
                rootView.genderContainer.textField.text = gender.gender
            })
            .disposed(by: disposeBag)

        gender.connect()
            .disposed(by: disposeBag)

        guard let user: User = try? cache.readFromDisk(name: "userInfo"),
              let profile: Profile = try? cache.readFromDisk(name: "profileInfo")
        else { return }
        rootView.setData(user: user, profile: profile)
        let result = output.updatedAccount.publish()

        result.element
            .subscribe(onNext: { [unowned self]  _ in
                self.saveTapped?()
            }).disposed(by: disposeBag)

        result.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)

        result.connect()
            .disposed(by: disposeBag)
        rootView.saveButton.rx.tap
            .subscribe(onNext: { _  in
                print("tapped")
            })
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
