import RxSwift
import YandexMapsMobile
import CoreLocation
import UIKit

class MakeOrderViewController: ViewController, MakeOrderModule, ViewHolder {

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
        bindView()
        configureMap()
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(
            input: .init(
                showLocationList: rootView.locationView.uiControl.rx.controlEvent(.touchUpInside).asObservable(),
                currentLocation: currentLocation
            )
        )
        
        let adressList = output.savedLocationList
        adressList.subscribe(onNext: { [unowned self] locations in
            self.showAdressList(adressList: locations)
        })
        .disposed(by: disposeBag)
        
        let distance = output.deliveryDistance
        
        distance.subscribe(onNext: { [unowned self] distance in
            self.rootView.deliveryView.setup(subTitle: "Расстояние доставки \(distance / 1000) км")
            self.distance.onNext(distance)
        })
        .disposed(by: disposeBag)
        
        let currentLocation = output.currentLocationName
        
        currentLocation.subscribe(onNext: { [unowned self] location in
            self.rootView.locationView.setup(subTitle: location.name)
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
            self.rootView.addressView.setupAdressName(adress: location.name)
        })
        .disposed(by: disposeBag)
        
        viewModel.dishList.wishDishList
            .bind(to: rootView.tableView.rx.items(BasketItemViewCell.self)) { _, model, cell  in
                cell.setup(product: model)
                cell.addProduct = { product in
                    self.changeDishList(action: .addToDish(product!))
                }
                cell.removeProduct = { product in
                    self.changeDishList(action: .removeFromDish(product))
                }
                cell.contentView.isUserInteractionEnabled = false
            }.disposed(by: disposeBag)
        
        Observable.combineLatest(viewModel.dishList.wishDishList, rate.element)
            .subscribe(onNext: { [unowned self] products, rate in
                let amount = products.map { $0.price * ($0.shoppingCount ?? 0)}
                let totalSum = amount.reduce(0,+)
                if totalSum < 2000 {
                    self.totalSum.onNext(totalSum + 600 + rate.rate)
                    self.rootView.setupAmount(totalSum: totalSum + 600, delivery: rate.rate)
                } else {
                    self.rootView.setupAmount(totalSum: totalSum, delivery: rate.rate)
                    self.totalSum.onNext(totalSum + rate.rate)
                }
                self.rootView.setupAmount(totalSum: totalSum, delivery: rate.rate)
            })
            .disposed(by: disposeBag)
        
        totalSum.subscribe(onNext: { [unowned self] sum in
            let bonusSpend = self.viewModel.userInfo.balance ?? 0 > sum ? sum : self.viewModel.userInfo.balance ?? 0
            let sumSpend = self.viewModel.userInfo.balance ?? 0 > sum ? 0 : self.viewModel.userInfo.balance ?? 0 - sum
            self.rootView.bonusChoiceView.setupBonus(bonus: Double(bonusSpend))
            self.rootView.bonusChoiceView.setupSpendedMoney(money: Double(sumSpend))
        })
        .disposed(by: disposeBag)
        
        rootView.bonusChoiceView.choiceSwitch.rx.isOn.map { !$0 }
            .bind(to: rootView.bonusChoiceView.fullPayBonusStackView.rx.isHidden)
            .disposed(by: disposeBag)
        rootView.addressView.control.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                self.onMapShowDidSelect?()
            }).disposed(by: disposeBag)
        
    }
    
    func changeDishList(action: DishListAction) {
       _ = viewModel.dishList.changeDishList(dishAction: action)
    }
    
    private func bindView() {
        rootView.setupUserInfo(storage: viewModel.userInfo)
        rootView.tableView.rowHeight = 100
        rootView.tableView.estimatedRowHeight = 100
        rootView.setOrderType(orderType: orderType)
        if let coordinate = locationManager.location?.coordinate {
            currentLocation.onNext(DeliveryLocation(point: MapPoint(latitude: coordinate.latitude, longitude: coordinate.longitude), name: ""))
        }
    }
    
    private func configureMap() {
        let transitionViewModel = MapTransitionViewModel(duration: 0.1, animationType: .smooth, zoom: 11)
        viewModel.mapManager.moveTo(in: rootView.mapView, point: MapPoint(latitude: 42.340782, longitude: 69.596329), transitionViewModel: transitionViewModel)
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
}
