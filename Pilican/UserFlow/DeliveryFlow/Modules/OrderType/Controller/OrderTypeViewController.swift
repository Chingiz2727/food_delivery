import UIKit
import YandexMapsMobile
import CoreLocation
import RxSwift

class OrderTypeViewController: ViewController, ViewHolder, OrderTypeModule {
    var onDeliveryChoose: OnDeliveryChoose?
    
    typealias RootViewType = OrderTypeView
    private let orderCases = OrderType.allCases
    private let disposeBag = DisposeBag()
    private var dishList: DishList
    private let mapManager: MapManager<YandexMapViewModel>
    private let locationManager = CLLocationManager()
    private var userCoordinate = PublishSubject<CLLocationCoordinate2D>()
    private let currentLocation = PublishSubject<DeliveryLocation>()
    private var userLatitude: Double = 0
    private var userLongitude: Double = 0
    private var distance: Double = 0
    private var searchManager: YMKSearchManager?
    private var searchSession: YMKSearchSession?
    
    init(dishList: DishList, mapManager: MapManager<YandexMapViewModel>) {
        self.dishList = dishList
        self.mapManager = mapManager
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func loadView() {
        view = OrderTypeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        bindViewModel()
        setupMap()
        navigationItem.title = "Выберите доставку"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dishList = assembler.resolver.resolve(DishList.self)!
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
        dishList.wishDishList
            .subscribe(onNext: { [unowned self] product in
                self.rootView.setup(product: product)
            })
            .disposed(by: disposeBag)
        
        rootView.tableView.rx.itemSelected
            .withLatestFrom(userCoordinate) { index, coordinate in
                return (index.row, coordinate)
            }.subscribe(onNext: { [unowned self] item in
                if item.0 != 2 {
                    self.onDeliveryChoose?(self.orderCases[item.0], item.1)
                }
            }).disposed(by: disposeBag)
            
        
        Observable.just(orderCases)
            .bind(to: rootView.tableView.rx.items(OrderTypeTableViewCell.self)) { _, model, cell in
                cell.setup(orderType: model)
            }.disposed(by: disposeBag)
        
        if let coordinate = locationManager.location?.coordinate {
            self.userCoordinate.onNext(coordinate)
            let retail = self.dishList.retail
            self.mapManager.getDistance(firstPoint: MapPoint(latitude: coordinate.latitude, longitude: coordinate.longitude), secondPoint: MapPoint(latitude: retail?.latitude ?? 0, longitude: retail?.longitude ?? 0), completion: { [unowned self] distance in
                self.distance = distance
                self.rootView.headerView.descriptionLabel.text = "\(distance) км до \(String(describing: retail?.name ?? ""))"
            })
            
        }
    }
    
    private func setupMap() {
        let latitude =  42.340782
        let longitude = 69.596329
        mapManager.showCurrentLocation(in: rootView.headerView.mapView)
        let viewModel = MapTransitionViewModel(duration: 0.1, animationType: .smooth, zoom: 13)
        mapManager.moveTo(in: rootView.headerView.mapView, point: MapPoint(latitude: latitude, longitude: longitude), transitionViewModel: viewModel)
    }
}
extension OrderTypeViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard let coordinate = manager.location else { return }
    }
}
