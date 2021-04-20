import UIKit
import CoreLocation
import RxSwift

class OrderTypeViewController: ViewController, ViewHolder, OrderTypeModule {
    var onDeliveryChoose: OnDeliveryChoose?
    
    typealias RootViewType = OrderTypeView
    private let orderCases = OrderType.allCases
    private let disposeBag = DisposeBag()
    private let dishList: DishList
    private let mapManager: MapManager<YandexMapViewModel>
    private let locationManager = CLLocationManager()
    private let currentLocation = PublishSubject<DeliveryLocation>()
    
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
        
        locationManager.delegate = self
        if let coordinate = locationManager.location?.coordinate {
            currentLocation.onNext(DeliveryLocation(point: MapPoint(latitude: coordinate.latitude, longitude: coordinate.longitude), name: ""))
        }
        
        currentLocation.subscribe(onNext: { [unowned self] location in
            let retail = self.dishList.retail
            let distance = self.mapManager.getDistance(firstPoint: location.point, secondPoint: MapPoint(latitude: retail?.latitude ?? 0, longitude: retail?.longitude ?? 0)).rounded() / 1000
            self.rootView.headerView.descriptionLabel.text = "\(distance) км до \(String(describing: retail?.name ?? ""))"
        })
        .disposed(by: disposeBag)
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
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        guard let coordinate = manager.location else { return }
        self.currentLocation.onNext(DeliveryLocation(point: MapPoint(latitude: coordinate.coordinate.latitude, longitude: coordinate.coordinate.longitude), name: ""))
    }
}
