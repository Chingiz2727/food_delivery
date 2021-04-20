import RxSwift
import YandexMapsMobile
import CoreLocation
import UIKit

class MakeOrderViewController: ViewController, MakeOrderModule, ViewHolder {

    typealias RootViewType = MakeOrderView
    var onMapShowDidSelect: Callback?
    private let viewModel: MakeOrderViewModel
    private let disposeBag = DisposeBag()
    private var searchManager: YMKSearchManager?
    private var searchSession: YMKSearchSession?
    private let currentLocation = PublishSubject<MapPoint>()
    private let selectedLocationObject = PublishSubject<DeliveryLocation>()
    private let locationManager = CLLocationManager()
    
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
        })
        .disposed(by: disposeBag)
        
        let currentLocation = output.currentLocationName
        
        currentLocation.subscribe(onNext: { [unowned self] location in
            self.rootView.locationView.setup(subTitle: location.name)
            self.selectedLocationObject.onNext(location)
        })
        .disposed(by: disposeBag)
        
        selectedLocationObject.subscribe(onNext: { [unowned self] location in
            self.rootView.addressView.setupAdressName(adress: location.name)
        })
        .disposed(by: disposeBag)
        viewModel.dishList.wishDishList
            .do(onNext: { [unowned self] products in
                let amount = products.map { $0.price * ($0.shoppingCount ?? 0)}
                let totalSum = amount.reduce(0,+)
                self.rootView.setupAmount(totalSum: totalSum)
            })
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
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        if let coordinate = locationManager.location?.coordinate {
            currentLocation.onNext(MapPoint(latitude: coordinate.latitude, longitude: coordinate.longitude))
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
                self.selectedLocationObject.onNext(adress)
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
        self.currentLocation.onNext(MapPoint(latitude: coordinate.coordinate.latitude, longitude: coordinate.coordinate.longitude))
    }
}
