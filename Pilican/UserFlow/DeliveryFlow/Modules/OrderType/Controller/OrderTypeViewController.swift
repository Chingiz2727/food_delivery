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
    private let currentLocation = PublishSubject<DeliveryLocation>()
    private var userLatitude: Double = 0
    private var userLongitude: Double = 0
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
        locationManager.delegate = self
        let retail = self.dishList.retail
        self.mapManager.getDistance(firstPoint: MapPoint(latitude: locationManager.location?.coordinate.latitude ?? 0, longitude: locationManager.location?.coordinate.longitude ?? 0), secondPoint: MapPoint(latitude: retail?.latitude ?? 0, longitude: retail?.longitude ?? 0), completion: { [unowned self] distance in
            self.rootView.headerView.descriptionLabel.text = "\(distance) км до \(String(describing: retail?.name ?? ""))"

        })

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
            .subscribe(onNext: { [unowned self] path in
                if path.row != 2 {
                    self.onDeliveryChoose?(self.orderCases[path.row])
                }
            })
            .disposed(by: disposeBag)
        
        Observable.just(orderCases)
            .bind(to: rootView.tableView.rx.items(OrderTypeTableViewCell.self)) { _, model, cell in
                cell.setup(orderType: model)
            }.disposed(by: disposeBag)
        
        if let coordinate = locationManager.location?.coordinate {
            self.searchByLocation(mapPoint: MapPoint(latitude: coordinate.latitude, longitude: coordinate.longitude))
        }
        
        currentLocation.subscribe(onNext: { [unowned self] location in
            let retail = self.dishList.retail
            self.mapManager.getDistance(firstPoint: location.point, secondPoint: MapPoint(latitude: retail?.latitude ?? 0, longitude: retail?.longitude ?? 0), completion: { [unowned self] distance in
                self.rootView.headerView.descriptionLabel.text = "\(distance) км до \(String(describing: retail?.name ?? ""))"
            })
        })
        .disposed(by: disposeBag)
        
        if let coordinate = locationManager.location?.coordinate {
            searchByLocation(mapPoint: .init(latitude: coordinate.latitude, longitude: coordinate.longitude))
        }
    }
    
    private func setupMap() {
        let latitude =  42.340782
        let longitude = 69.596329
        mapManager.showCurrentLocation(in: rootView.headerView.mapView)
        let viewModel = MapTransitionViewModel(duration: 0.1, animationType: .smooth, zoom: 13)
        mapManager.moveTo(in: rootView.headerView.mapView, point: MapPoint(latitude: latitude, longitude: longitude), transitionViewModel: viewModel)
    }
    
    private func searchByLocation(mapPoint: MapPoint) {
        let options = YMKSearchOptions()
        options.geometry = true
        // swiftlint:disable line_length
        searchSession = searchManager?.submit(with: YMKPoint(latitude: mapPoint.latitude, longitude: mapPoint.longitude), zoom: 18, searchOptions: options, responseHandler: { [unowned self] (res, err) in
            if let name = res?.collection.children[0].obj?.name, let coordinate = res?.collection.children[0].obj?.geometry[0].point {
                let deliveryLocation = DeliveryLocation(point: MapPoint(latitude: coordinate.latitude, longitude: coordinate.longitude), name: name)
                self.currentLocation.onNext(deliveryLocation)
            }
        })
    }
}
extension OrderTypeViewController: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard let coordinate = manager.location else { return }
        self.searchByLocation(mapPoint: MapPoint(latitude: coordinate.coordinate.latitude, longitude: coordinate.coordinate.longitude))
    }

    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard let coordinate = manager.location else { return }
        self.searchByLocation(mapPoint: MapPoint(latitude: coordinate.coordinate.latitude, longitude: coordinate.coordinate.longitude))
    }
}
