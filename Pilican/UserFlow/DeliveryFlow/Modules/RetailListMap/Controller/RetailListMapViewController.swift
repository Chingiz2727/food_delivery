import RxSwift
import CoreLocation
import UIKit

class RetailListMapViewController: ViewController, ViewHolder, RetailListMapModule {
    typealias RootViewType = RetailListMapView
    
    var onDeliveryRetailSelect: OnDeliveryRetailSelected?

    private let locationSubject: PublishSubject<MapPoint> = .init()
    private let viewModel: RetailListMapViewModel
    private let mapManager: MapManager<YandexMapViewModel>
    private let locationManager: CLLocationManager
    private let secondManager = CLLocationManager()
    private let disposeBag = DisposeBag()
    private let userLocationStatusSubject: PublishSubject<UserLocationStatus> = .init()

    init(mapManager: MapManager<YandexMapViewModel>, locationManager: CLLocationManager, viewModel: RetailListMapViewModel) {
        self.mapManager = mapManager
        self.locationManager = locationManager
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func loadView() {
        view = RetailListMapView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Карта" 
        bindViewModel()
        configureView()
        setupMap()
    }

    private func bindViewModel() {
        let output = viewModel.transform(input: .init(coordinates: locationSubject))

        let retaillist = output.retailList.publish()

        retaillist.loading
            .bind(to: ProgressView.instance.rx.loading)
            .disposed(by: disposeBag)

        retaillist.element
            .map { $0.retails }
            .do(onNext: { [unowned self] retails in
                retails.forEach { retail in
                    // swiftlint:disable line_length
                    self.mapManager.createAnnotation(in: self.rootView.mapView, at: MapPoint(latitude: retail.latitude, longitude: retail.longitude), image: Images.mapIcon.image, associatedData: retail)
                }
                self.rootView.drawerView.isHidden = retails.isEmpty
            })
            .bind(to: rootView.tableView.rx.items(DeliveryRetailListTableViewCell.self)) { _, model, cell  in
                cell.setRetail(retail: model)
            }
            .disposed(by: disposeBag)

        retaillist.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)

        retaillist.connect()
            .disposed(by: disposeBag)

        Observable.combineLatest(retaillist.element, rootView.tableView.rx.itemSelected)
            .subscribe(onNext: { [unowned self] mapRetail, indexPath in
                let retail = mapRetail.retails[indexPath.row]
                self.onDeliveryRetailSelect?(retail)
            })
            .disposed(by: disposeBag)

        rootView.listButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.rootView.drawerView.setState(.middle, animated: true)
            })
            .disposed(by: disposeBag)

        rootView.currentLocationButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.moveToMyLocation()
            }).disposed(by: disposeBag)
    }
    private func configureView() {
        secondManager.delegate = self
        secondManager.requestAlwaysAuthorization()
        secondManager.startUpdatingLocation()
    }

    private func setupMap() {
        let latitude = secondManager.location?.coordinate.latitude ?? 42.340782
        let longitude = secondManager.location?.coordinate.longitude ?? 69.596329

        locationSubject.onNext(MapPoint(latitude: latitude, longitude: longitude))
        mapManager.showCurrentLocation(in: rootView.mapView)
        let viewModel = MapTransitionViewModel(duration: 0.1, animationType: .smooth, zoom: 13)
        mapManager.moveTo(in: rootView.mapView, point: MapPoint(latitude: latitude, longitude: longitude), transitionViewModel: viewModel)
    }

    private func moveToMyLocation() {
        if let coordinate = secondManager.location?.coordinate {
            let viewModel = MapTransitionViewModel(duration: 0.1, animationType: .smooth, zoom: 13)
            mapManager.moveTo(in: rootView.mapView, point: MapPoint(latitude: coordinate.latitude, longitude: coordinate.longitude), transitionViewModel: viewModel)
        }
    }
}

extension RetailListMapViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard let coordinates = manager.location?.coordinate else {
            userLocationStatusSubject.onNext(.disabled)
            return
        }
        userLocationStatusSubject.onNext(.enabled(lat: coordinates.latitude, long: coordinates.longitude))
    }
}
