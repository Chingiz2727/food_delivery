import RxSwift
import YandexMapsMobile
import CoreLocation
import UIKit
import PassKit

// swiftlint:disable function_body_length

class MakeOrderViewController: ViewController, MakeOrderModule, ViewHolder, PKPaymentAuthorizationViewControllerDelegate {
    var putAddress: PutAddress?
    
    var orderError: OrderError?
    var orderSuccess: OrderSuccess?
    var emptyDishList: EmptyDishList?
    
    typealias RootViewType = MakeOrderView
    var onMapShowDidSelect: Callback?
    var orderType: OrderType!
    var totalSumAmount: NSDecimalNumber = 0
    private let userLocation: CLLocationCoordinate2D
    private let viewModel: MakeOrderViewModel
    private let disposeBag = DisposeBag()
    private var searchManager: YMKSearchManager?
    private var searchSession: YMKSearchSession?
    private let currentLocation = PublishSubject<DeliveryLocation>()
    private let distance: PublishSubject<Double> = .init()
    private let locationManager = CLLocationManager()
    private let totalSum: BehaviorSubject<Int> = .init(value: 0)
    private let addAmountSubject: BehaviorSubject<Int> = .init(value: 0)
    private let descriptionSubject: BehaviorSubject<String> = .init(value: "")
    private let fullAmountSubject: BehaviorSubject<Int> = .init(value: 0)
    private let foodAmountSubject: BehaviorSubject<Int> = .init(value: 0)
    private let deliveryAmountSubject: BehaviorSubject<Int> = .init(value: 0)
    private let useCashbackSubject: BehaviorSubject<Bool> = .init(value: false)
    private let analytics = assembler.resolver.resolve(PillicanAnalyticManager.self)!
    private let commerceManager = assembler.resolver.resolve(PillicanCommerceManager.self)!
    
    init(viewModel: MakeOrderViewModel, userLocation: CLLocationCoordinate2D) {
        self.viewModel = viewModel
        self.userLocation = userLocation
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func loadView() {
        view = MakeOrderView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        searchManager = YMKSearch.sharedInstance().createSearchManager(with: .combined)
        bindViewModel()
        configureMap()
        viewModel.orderType = orderType.title == "Доставка Pillikan" ? 1 : 2
        navigationItem.title = "Оформить заказ \(viewModel.dishList.retail?.name ?? "")"
        bindView()
        currentLocation.onNext(.init(point: .init(latitude: userLocation.latitude, longitude: userLocation.longitude), name: ""))
        analytics.log(.deliverytabbar)
        let ymkProducts: [YMKOrderProduct] = viewModel.dishList.products.map { product in
            return YMKOrderProduct(productId: product.id, productName: product.name, productCount: product.shoppingCount ?? 1, productPrice: product.price)
        }
        commerceManager.log(.beginCommerce(query: viewModel.dishList.retail?.name ?? "", products: ymkProducts))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabbar = tabBarController as? HomeTabBarViewController {
            tabbar.tabBar.isHidden = true
            HomeTabBarViewController.qrScanButton.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabbar = tabBarController as? HomeTabBarViewController {
            tabbar.tabBar.isHidden = false
            HomeTabBarViewController.qrScanButton.isHidden = false
        }
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(
            input: .init(
                showLocationList: rootView.locationView.uiControl.rx.controlEvent(.touchUpInside).asObservable(),
                currentLocation: currentLocation,
                addAmount: addAmountSubject,
                description: descriptionSubject,
                fullAmount: fullAmountSubject,
                foodAmount: foodAmountSubject,
                useCashback: useCashbackSubject,
                deliveryAmount: deliveryAmountSubject,
                makeOrderTapped: rootView.payAmountView.payButton.rx.tap.asObservable()))

        let order = output.orderResponse.publish()

        order.element
            .subscribe(onNext: { [unowned self] res in
                if res.status == 200 {
                    self.analytics.log(.cartpay)
                    let ymkProducts: [YMKOrderProduct] = viewModel.dishList.products.map { product in
                        return YMKOrderProduct(productId: product.id, productName: product.name, productCount: product.shoppingCount ?? 1, productPrice: product.price)
                    }
                    commerceManager.log(.purchaseCommerce(query: viewModel.dishList.retail?.name ?? "", products: ymkProducts))
                    self.orderSuccess?(res.order?.id ?? 0)
                    viewModel.dishList.products = []
                } else {
                    self.orderError?()
                }
            }).disposed(by: disposeBag)

        order.loading
            .bind(to: ProgressView.instance.rx.loading)
            .disposed(by: disposeBag)

        order.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)

        order.connect()
            .disposed(by: disposeBag)

        let adressList = output.savedLocationList
        adressList.subscribe(onNext: { [unowned self] locations in
            if !locations.isEmpty {
                self.showAdressList(adressList: locations)
            }
        })
        .disposed(by: disposeBag)

        let distance = output.deliveryDistance

        distance.subscribe(onNext: { [unowned self] distance in
            if orderType.title == "Доставка Pillikan" {
                self.rootView.deliveryView.setup(subTitle: "Расстояние доставки \(distance) км")
            }
        })
        .disposed(by: disposeBag)

        let currentLocation = output.currentLocationName

        currentLocation.subscribe(onNext: { [unowned self] location in
            if orderType.title == "Доставка Pillikan" {
                self.analytics.log(.cartaddress)
                self.rootView.locationView.setup(subTitle: location.name)
            } else {
                self.rootView.locationView.setup(subTitle: viewModel.dishList.retail?.address ?? "")
            }
        })
        .disposed(by: disposeBag)

        let rate = output.deliveryRate.publish()

        rate.subscribe(onNext: { [unowned self] rate in
            print(rate)
        })
        .disposed(by: disposeBag)

        rate.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)

        rate.connect()
            .disposed(by: disposeBag)

        currentLocation.subscribe(onNext: { [unowned self] location in
            if orderType.title == "Доставка Pillikan" {
                self.rootView.addressView.setupAdressName(adress: location.name)
            } else {
                self.rootView.addressView.setupAdressName(adress: viewModel.dishList.retail?.address ?? "")
            }
        })
        .disposed(by: disposeBag)

        viewModel.dishList.wishDishList
            .bind(to: rootView.tableView.rx.items(BasketItemViewCell.self)) { _, model, cell  in
                cell.setup(product: model)
                cell.addProduct = { [unowned self] product in
                    self.analytics.log(.cartaddfood)
                    self.changeDishList(action: .addToDish(product!))
                }
                cell.removeProduct = { product in
                    self.analytics.log(.cartdeletefood)
                    self.changeDishList(action: .removeFromDish(product))
                }
                cell.contentView.isUserInteractionEnabled = false
            }.disposed(by: disposeBag)

        Observable.combineLatest(viewModel.dishList.wishDishList, rate.element)
            .subscribe(onNext: { [unowned self] products, rate in
                if products.isEmpty {
                    emptyDishList?()
                }
                let amount = products.map { $0.price * ($0.shoppingCount ?? 0) }
                let totalSum = amount.reduce(0, +)
                self.foodAmountSubject.onNext(totalSum)
                if orderType.title == "Доставка Pillikan" {
                    if totalSum < rate.minimalRate {
                        self.addAmountSubject.onNext(rate.minimalRate)
                        self.totalSum.onNext(totalSum)
                        self.deliveryAmountSubject.onNext(rate.rate)
                        self.rootView.setupAmount(totalSum: totalSum, delivery: rate.rate, orderType: orderType)
                        self.fullAmountSubject.onNext(totalSum + rate.rate + rate.minimalRate)
                    } else {
                        self.addAmountSubject.onNext(0)
                        self.deliveryAmountSubject.onNext(rate.rate)
                        self.rootView.setupAmount(totalSum: totalSum, delivery: rate.rate, orderType: orderType)
                        self.totalSum.onNext(totalSum + rate.rate)
                        self.fullAmountSubject.onNext(totalSum + rate.rate)
                    }
                } else {
                    self.totalSum.onNext(totalSum)
                    self.rootView.setupAmount(totalSum: totalSum, delivery: 0, orderType: orderType)
                    self.rootView.payAmountView.clearExtraCost()
                    self.fullAmountSubject.onNext(totalSum)
                }
            })
            .disposed(by: disposeBag)

        fullAmountSubject.subscribe(onNext: { [unowned self] sum in
            guard let bonus = self.viewModel.userInfo.balance else { return }
            let bonusSpend = bonus > sum ? sum : self.viewModel.userInfo.balance ?? 0
            let sumSpend = bonus > sum ? 0 : sum - bonus
            self.rootView.bonusChoiceView.setupBonus(bonus: Double(bonusSpend))
            self.rootView.bonusChoiceView.setupSpendedMoney(money: Double(sumSpend))
        })
        .disposed(by: disposeBag)

        rootView.bonusChoiceView.choiceSwitch.rx.isOn.map { !$0 }
            .bind(to: rootView.bonusChoiceView.fullPayBonusStackView.rx.isHidden)
            .disposed(by: disposeBag)
        
        rootView.bonusChoiceView.choiceSwitch.rx.isOn.bind(to: useCashbackSubject).disposed(by: disposeBag)
        rootView.addressView.control.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                self.onMapShowDidSelect?()
            }).disposed(by: disposeBag)

        rootView.commentView.textField.rx.text
            .subscribe(onNext: { [unowned self] text in
                descriptionSubject.onNext(text ?? "")
            }).disposed(by: disposeBag)

        putAddress = { [unowned self] address in
            self.rootView.addressView.adressLabel.text = address.name
            self.currentLocation.onNext(address)
        }

        if orderType == .takeAway {
            rootView.setupTakeAway()
            viewModel.dishList.wishDishList
                .subscribe(onNext: { [unowned self] products in
                    if products.isEmpty {
                        emptyDishList?()
                    }
                    let amount = products.map { $0.price * ($0.shoppingCount ?? 0) }
                    let totalSum = amount.reduce(0, +)
                    self.foodAmountSubject.onNext(totalSum)
                    if orderType.title == "Доставка Pillikan" {
                        if totalSum < 1499 {
                            self.addAmountSubject.onNext(0)
                            self.totalSum.onNext(totalSum)
                            self.rootView.setupAmount(totalSum: totalSum, delivery: 0, orderType: orderType)
                        } else {
                            self.addAmountSubject.onNext(0)
                            self.rootView.setupAmount(totalSum: totalSum, delivery: 0, orderType: orderType)
                            self.totalSum.onNext(totalSum)
                            self.fullAmountSubject.onNext(totalSum)
                        }
                    } else {
                        self.totalSum.onNext(totalSum)
                        self.rootView.setupAmount(totalSum: totalSum, delivery: 0, orderType: orderType)
                        self.rootView.payAmountView.clearExtraCost()
                        self.fullAmountSubject.onNext(totalSum)
                    }
                })
                .disposed(by: disposeBag)
        }
        useCashbackSubject.subscribe(onNext: { [unowned self] isOn in
            if isOn {
                self.analytics.log(.cartbonus)
            }
        })
        .disposed(by: disposeBag)
        
        totalSum.subscribe(onNext: { [unowned self] sum in
            self.totalSumAmount = NSDecimalNumber(value: sum)
        })
        .disposed(by: disposeBag)
    }

    func changeDishList(action: DishListAction) {
        _ = viewModel.dishList.changeDishList(dishAction: action)
    }

    private func bindView() {
        rootView.setupUserInfo(storage: viewModel.userInfo)
        rootView.tableView.rowHeight = 100
        rootView.tableView.estimatedRowHeight = 100
        rootView.setOrderType(orderType: orderType, address: viewModel.dishList.retail?.address ?? "")
        rootView.payAmountView.pkPaymentButton.addTarget(self, action: #selector(makeApplePayRequest), for: .touchUpInside)
//        if let coordinate = locationManager.location?.coordinate {
//            currentLocation.onNext(DeliveryLocation(point: MapPoint(latitude: coordinate.latitude, longitude: coordinate.longitude), name: ""))
//        }
    }

    private func configureMap() {
        let transitionViewModel = MapTransitionViewModel(duration: 0.1, animationType: .smooth, zoom: 11)
        viewModel.mapManager.moveTo(in: rootView.mapView, point: MapPoint(latitude: 42.340782, longitude: 69.596329), transitionViewModel: transitionViewModel)
        // swiftlint:disable line_length
        viewModel.mapManager.createAnnotation(in: rootView.mapView, at: MapPoint(latitude: viewModel.dishList.retail?.latitude ?? 0, longitude: viewModel.dishList.retail?.longitude ?? 0), image: Images.mapIcon.image, associatedData: nil)
        viewModel.mapManager.showCurrentLocation(in: rootView.mapView)
    }

    private func showAdressList(adressList: [DeliveryLocation]) {
        let alert = UIAlertController(title: "Выберите адрес", message: nil, preferredStyle: .actionSheet)
        adressList.forEach { adress in
            let action = UIAlertAction(title: adress.name, style: .default) { [unowned self] _ in
                self.currentLocation.onNext(adress)
                self.rootView.locationView.setup(subTitle: adress.name)
            }
            alert.addAction(action)
        }
        present(alert, animated: true, completion: nil)
        
    }
    
    @objc private func makeApplePayRequest() {
        let paymentRequest = PKPaymentRequest()
        paymentRequest.merchantIdentifier = "merchant.com.wezom.Pillikan"
        paymentRequest.supportedNetworks = [.visa, .masterCard]
        paymentRequest.countryCode = "KZ"
        paymentRequest.currencyCode = "KZT"
        
        paymentRequest.merchantCapabilities = .capability3DS
        paymentRequest.paymentSummaryItems = [PKPaymentSummaryItem(label: "Оплата Pillikan", amount: totalSumAmount)]
        let controller = PKPaymentAuthorizationController(paymentRequest: paymentRequest)
        controller.delegate = self
        controller.present(completion: nil)
    }
}

extension MakeOrderViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard let coordinate = manager.location else { return }
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard let coordinate = manager.location else { return }
    }
}

extension MakeOrderViewController: PKPaymentAuthorizationControllerDelegate {
    func paymentAuthorizationControllerDidFinish(_ controller: PKPaymentAuthorizationController) {
        controller.dismiss(completion: nil)
    }
    
    func paymentAuthorizationController(_ controller: PKPaymentAuthorizationController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        if payment.token.transactionIdentifier != "" {
            do{
                let json = try JSONSerialization.jsonObject(with: payment.token.paymentData, options: []) as? [String : Any]
                print(json)
            }catch{ print("erroMsg") }
            
            completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        } else {
            completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
        }
    }
    func paymentAuthorizationViewControllerDidFinish(_ controller: PKPaymentAuthorizationViewController) {
        controller.dismiss(animated: true, completion: nil)
    }
    
    func paymentAuthorizationViewController(_ controller: PKPaymentAuthorizationViewController, didAuthorizePayment payment: PKPayment, handler completion: @escaping (PKPaymentAuthorizationResult) -> Void) {
        if payment.token.transactionIdentifier != "" {
            completion(PKPaymentAuthorizationResult(status: .success, errors: nil))
        } else {
            completion(PKPaymentAuthorizationResult(status: .failure, errors: nil))
        }
    }
}
