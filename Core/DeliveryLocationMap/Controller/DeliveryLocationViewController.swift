import RxSwift
import CoreLocation
import YandexMapsMobile
import UIKit

class DeliveryLocationViewController: UIViewController, DeliveryLocationModule, ViewHolder {
    typealias RootViewType = DeliveryLocationMapView
    var onlocationDidSelect: OnLocationDidSelect?
    private let deliveryLocationObject: PublishSubject<DeliveryLocation> = .init()
    private let viewModel: DeliveryLocationMapViewModel
    private let disposeBag = DisposeBag()
    private let userLocationStatusSubject: PublishSubject<UserLocationStatus> = .init()

    private let locationManager = CLLocationManager()
    override func loadView() {
        view = DeliveryLocationMapView()
    }
    
    init(viewModel: DeliveryLocationMapViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        viewModel.mapManager.setupCameraListener(in: rootView.mapView)
        bindViewModel()
        setupMap()
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: .init(text: rootView.textField.rx.text.unwrap()))
        
        let locationArray = output.locationArray.share()
        
        locationArray.bind(to: rootView.tableView.rx.items(UITableViewCell.self)) { _, model ,cell in
            cell.textLabel?.text = model.name
        }
        .disposed(by: disposeBag)
        
        let location = output.locationName.share()
        location.subscribe(onNext: { [unowned self] location in
            self.rootView.textField.text = location.name
            self.deliveryLocationObject.onNext(location)
        }).disposed(by: disposeBag)
        
        rootView.saveButton.rx.tap
            .withLatestFrom(deliveryLocationObject)
            .subscribe(onNext: { [unowned self] location in
                self.saveLocationToCache(location: location)
                self.onlocationDidSelect?(location)
            })
            .disposed(by: disposeBag)
        
        rootView.textField.rx.text.unwrap()
            .subscribe(onNext: { [unowned self] text in
                self.rootView.tableView.isHidden = text.isEmpty
            })
            .disposed(by: disposeBag)
        
        rootView.tableView.rx.itemSelected
            .withLatestFrom(locationArray) { (index, array) -> DeliveryLocation in
                return array[index.row]
            }.subscribe(onNext: { [unowned self] location in
                self.selectLocationAtList(location: location)
            })
            .disposed(by: disposeBag)
    }
    
    private func selectLocationAtList(location: DeliveryLocation) {
        rootView.textField.text = location.name
        viewModel.mapManager.moveTo(in: rootView.mapView, point: location.point, transitionViewModel: .init(duration: 0.3, animationType: .linear, zoom: 18))
        self.rootView.tableView.isHidden =  true
        deliveryLocationObject.onNext(location)
    }
    
    private func setupMap() {
        let latitude = locationManager.location?.coordinate.latitude ?? 42.340782
        let longitude = locationManager.location?.coordinate.longitude ?? 69.596329
        
        viewModel.mapManager.showCurrentLocation(in: rootView.mapView)
        let transitionViewModel = MapTransitionViewModel(duration: 0.1, animationType: .smooth, zoom: 13)
        viewModel.mapManager.moveTo(in: rootView.mapView, point: MapPoint(latitude: latitude, longitude: longitude), transitionViewModel: transitionViewModel)
    }
    
    private func saveLocationToCache(location: DeliveryLocation) {
        viewModel.saveAdress(adress: location)
    }
}

extension DeliveryLocationViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        guard let coordinates = manager.location?.coordinate else {
            userLocationStatusSubject.onNext(.disabled)
            return
        }
        userLocationStatusSubject.onNext(.enabled(lat: coordinates.latitude, long: coordinates.longitude))
    }
}
