import RxSwift
import UIKit

final class RegisterViewController: ViewController, ViewHolder, RegisterModule {
    typealias RootViewType = RegisterView

    var qrScanTapped: QrScanTapped?
    var registerTapped: RegisterTapped?
    var putPromoCodeToText: PutPromoCodeToText?

    private var cityPickerDelegate: CityPickerViewDelegate
    private var cityPickerDataSource: CityPickerViewDataSource

    private let pickerView = UIPickerView()
    private let disposeBag = DisposeBag()
    private var registerStatus: BehaviorSubject<RegistrationStatus> = .init(value: .getSMS)
    private let viewModel: RegistrationViewModel
    private let sessionStorage: UserSessionStorage
    private let sendSms = PublishSubject<Void>()
    init(viewModel: RegistrationViewModel, sessionStorage: UserSessionStorage) {
        self.viewModel = viewModel
        self.sessionStorage = sessionStorage
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
        rootView.setViewStatus(status: .getSMS)
    }

    override func customBackButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }

    private func bindViewModel() {
        let input = RegistrationViewModel.Input(
            registerTapped: Observable.merge(rootView.registerButton.rx.tap.asObservable(), sendSms.asObservable()),
            getSmsTapped: rootView.sendSmsButton.rx.tap.asObservable(),
            loadCity: rx.methodInvoked(#selector(viewWillAppear(_:))).map { _ in  },
            userLogin: rootView.loginContainer.textField.phoneText.asObservable(),
            userName: rootView.userNameContainer.textField.rx.text.asObservable(),
            promoCode: rootView.promoCodeContainer.textField.rx.text.asObservable(),
            city: cityPickerDelegate.selectedCity.asObservable(),
            smsCode: rootView.smsContainer.textField.codeText
        )

        let output = viewModel.transform(input: input)

        rootView.promoCodeContainer.textField.qrButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.qrScanTapped?()
            })
            .disposed(by: disposeBag)

        let result = output.token.publish()

        result.element
            .subscribe(onNext: { [unowned self] result in
                self.sessionStorage.accessToken = result.token.accessToken
                self.sessionStorage.refreshToken = result.token.refreshToken
                self.registerTapped?()
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
            self.cityPickerDelegate.city = city
            cityPickerDelegate.selectedCity.onNext(city.first!)
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

        registerStatus.subscribe(onNext: { [unowned self] status in
            rootView.setViewStatus(status: status)
        })
        .disposed(by: disposeBag)

        putPromoCodeToText = { [unowned self] promo in
            self.rootView.promoCodeContainer.textField.text = promo
        }

        let getSms = output.getSms.publish()

        getSms.element
            .subscribe(onNext: { [unowned self] status in
                switch status.status {
                case 200:
                    self.registerStatus.onNext(.register)
                default:
                    break
                }
            })
            .disposed(by: disposeBag)

        getSms.loading
            .bind(to: ProgressView.instance.rx.loading)
            .disposed(by: disposeBag)

        getSms.connect()
            .disposed(by: disposeBag)

        getSms.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)
        
        rootView.loginContainer.textField.isFilled
            .subscribe(onNext: { [unowned self] filled in
                self.rootView.sendSmsButton.isEnabled = filled
            })
            .disposed(by: disposeBag)
        
        rootView.smsContainer.textField.isFilled
            .subscribe(onNext: { [unowned self] isFilled in
                if isFilled {
                    self.sendSms.onNext(())
                }
            })
            .disposed(by: disposeBag)
    }

    private func setupPickerView() {
        pickerView.dataSource = cityPickerDataSource
        pickerView.delegate = cityPickerDelegate
        rootView.cityContainer.textField.inputView = pickerView
    }
}
