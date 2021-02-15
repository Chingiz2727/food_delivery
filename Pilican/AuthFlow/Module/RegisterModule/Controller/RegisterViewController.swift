import RxSwift
import UIKit

class RegisterViewController: UIViewController, ViewHolder, RegisterModule {
    typealias RootViewType = RegisterView

    var qrScanTapped: QrScanTapped?
    var registerTapped: RegisterTapped?

    private var cityPickerDelegate: CityPickerViewDelegate
    private var cityPickerDataSource: CityPickerViewDataSource

    private let pickerView = UIPickerView()
    private let disposeBag = DisposeBag()
    private let viewModel: RegistrationViewModel

    init(viewModel: RegistrationViewModel) {
        self.viewModel = viewModel
        self.cityPickerDelegate = CityPickerViewDelegate()
        self.cityPickerDataSource = CityPickerViewDataSource()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }
    
    override func loadView() {
        view = RegisterView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        setupPickerView()
    }

    private func bindViewModel() {
        let input = RegistrationViewModel.Input(
            registerTapped: rootView.registerButton.rx.tap.asObservable(),
            loadCity: rx.methodInvoked(#selector(viewWillAppear(_:))).map { _ in  },
            userLogin: rootView.loginContainer.textField.phoneText.asObservable(),
            userName: rootView.userNameContainer.textField.rx.text.asObservable(),
            promoCode: rootView.promoCodeContainer.textField.rx.text.asObservable(),
            city: cityPickerDelegate.selectedCity.asObservable(),
            smsCode: rootView.smsContainer.textField.rx.text.asObservable()
        )

        let output = viewModel.transform(input: input)
        rootView.promoCodeContainer.textField.qrButton.rx.tap
            .subscribe(onDisposed: { [unowned self] in
                self.qrScanTapped?()
            })
            .disposed(by: disposeBag)

        let result = output.token.publish()
        result.element
            .subscribe(onNext: { token in
                print(token)
            })
            .disposed(by: disposeBag)

        result.loading
            .bind(to: ProgressView.instance.rx.loading)
            .disposed(by: disposeBag)

        result.connect()
            .disposed(by: disposeBag)

        result.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)

        let city = output.getCity.publish()
        city.subscribe(onNext: { [unowned self] city in
            self.cityPickerDataSource.city = city
            self.pickerView.reloadAllComponents()
        })
        .disposed(by: disposeBag)
    
        cityPickerDelegate.selectedCity
            .subscribe(onNext: { [unowned self] city in
                rootView.cityContainer.textField.text = city.name
            })
            .disposed(by: disposeBag)
        
        city.connect()
            .disposed(by: disposeBag)
    }

    private func setupPickerView() {
        pickerView.delegate = cityPickerDelegate
        pickerView.dataSource = cityPickerDataSource
        rootView.cityContainer.textField.inputView = pickerView
    }
}
