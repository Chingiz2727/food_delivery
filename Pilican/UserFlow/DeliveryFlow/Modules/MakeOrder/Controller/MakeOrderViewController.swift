import RxSwift
import YandexMapsMobile
import CoreLocation
import UIKit
// swiftlint:disable function_body_length

class MakeOrderViewController: ViewController, MakeOrderModule, ViewHolder {
    var putAddress: PutAddress?
    
    var orderError: OrderError?
    var orderSuccess: OrderSuccess?
    var emptyDishList: EmptyDishList?
    
    typealias RootViewType = MakeOrderView
    var onMapShowDidSelect: Callback?
    var orderType: OrderType!
    private let viewModel: MakeOrderViewModel
    private let disposeBag = DisposeBag()
    private var searchManager: YMKSearchManager?
    private var searchSession: YMKSearchSession?
    private let currentLocation = PublishSubject<DeliveryLocation>()
    private let distance = PublishSubject<Double>()
    private let locationManager = CLLocationManager()
    private let totalSum = PublishSubject<Int>()
    private let addAmountSubject = PublishSubject<Int>()
    private let descriptionSubject = PublishSubject<String>()
    private let fullAmountSubject = PublishSubject<Int>()
    private let foodAmountSubject = PublishSubject<Int>()
    private let deliveryAmountSubject = PublishSubject<Int>()
    private let useCashbackSubject = PublishSubject<Bool>()
    init(viewModel: MakeOrderViewModel) {
        self.viewModel = viewModel
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
        searchManager = YMKSearch.sharedInstance().createSearchManager(with: .combined)
        bindViewModel()
        configureMap()
        viewModel.orderType = orderType.title == "Доставка Pillikan" ? 1 : 2
        bindView()
    }
    private func bindViewModel() {
        let output = viewModel.transform(
            input: .init(
                showLocationList: rootView.locationView.uiControl.rx.controlEvent(.touchUpInside).asObservable(),
                currentLocation: currentLocation,
                addAmount: addAmountSubject,
                description: descriptionSubject,
                fullAmount: fullAmountSubject,
                userLocation: currentLocation,
                foodAmount: foodAmountSubject,
                useCashback: useCashbackSubject,
                deliveryAmount: deliveryAmountSubject,
                makeOrderTapped: rootView.payAmountView.payButton.rx.tap.asObservable()))

        let order = output.orderResponse.publish()

        order.element
            .subscribe(onNext: { [unowned self] res in
                if res.status == 200 {
                    viewModel.dishList.products = []
                    self.orderSuccess?(res.order?.id ?? 0)
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
                self.rootView.deliveryView.setup(subTitle: "Расстояние доставки \(distance / 1000) км")
            }
            self.distance.onNext(distance)
        })
        .disposed(by: disposeBag)

        let currentLocation = output.currentLocationName

        currentLocation.subscribe(onNext: { [unowned self] location in
            if orderType.title == "Доставка Pillikan" {
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
                    self.changeDishList(action: .addToDish(product!))
                }
                cell.removeProduct = { product in
                    self.changeDishList(action: .removeFromDish(product))
                }
                cell.contentView.isUserInteractionEnabled = false
            }.disposed(by: disposeBag)

        Observable.combineLatest(viewModel.dishList.wishDishList, rate.element)
            .subscribe(onNext: { [unowned self] products, rate in
                if products.isEmpty {
                    emptyDishList?()
                }
                let amount = products.map { $0.price * ($0.shoppingCount ?? 0)}
                let totalSum = amount.reduce(0, +)
                self.foodAmountSubject.onNext(totalSum)
                if orderType.title == "Доставка Pillikan" {
                    if totalSum < 2000 {
                        self.addAmountSubject.onNext(600)
                        self.totalSum.onNext(totalSum)
                        self.deliveryAmountSubject.onNext(rate.rate)
                        self.rootView.setupAmount(totalSum: totalSum, delivery: rate.rate, orderType: orderType)
                        self.fullAmountSubject.onNext(totalSum + rate.rate + 600)
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
            let bonusSpend = self.viewModel.userInfo.balance ?? 0 > sum ? sum : self.viewModel.userInfo.balance ?? 0
            let sumSpend = self.viewModel.userInfo.balance ?? 0 > sum ? 0 : self.viewModel.userInfo.balance ?? 0 - sum
            self.rootView.bonusChoiceView.setupBonus(bonus: Double(bonusSpend))
            self.rootView.bonusChoiceView.setupSpendedMoney(money: Double(sumSpend))
        })
        .disposed(by: disposeBag)

        rootView.bonusChoiceView.choiceSwitch.rx.isOn.map { !$0 }
            .bind(to: rootView.bonusChoiceView.fullPayBonusStackView.rx.isHidden)
            .disposed(by: disposeBag)
        useCashbackSubject.onNext(true)
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
    }

    func changeDishList(action: DishListAction) {
       _ = viewModel.dishList.changeDishList(dishAction: action)
    }

    private func bindView() {
        rootView.setupUserInfo(storage: viewModel.userInfo)
        rootView.tableView.rowHeight = 100
        rootView.tableView.estimatedRowHeight = 100
        rootView.setOrderType(orderType: orderType, address: viewModel.dishList.retail?.address ?? "")
        if let coordinate = locationManager.location?.coordinate {
            currentLocation.onNext(DeliveryLocation(point: MapPoint(latitude: coordinate.latitude, longitude: coordinate.longitude), name: ""))
        }
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
}

extension MakeOrderViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard let coordinate = manager.location else { return }
        self.currentLocation.onNext(DeliveryLocation(point: MapPoint(latitude: coordinate.coordinate.latitude, longitude: coordinate.coordinate.longitude), name: ""))
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard let coordinate = manager.location else { return }
        self.currentLocation.onNext(DeliveryLocation(point: MapPoint(latitude: coordinate.coordinate.latitude, longitude: coordinate.coordinate.longitude), name: ""))
    }
}
