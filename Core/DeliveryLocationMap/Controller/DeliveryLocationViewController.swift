import RxSwift
import CoreLocation
import YandexMapsMobile
import MapKit
import UIKit

class DeliveryLocationViewController: UIViewController, DeliveryLocationModule, ViewHolder {
    typealias RootViewType = DeliveryLocationMapView
    var onlocationDidSelect: OnLocationDidSelect?
    private let deliveryLocationObject: PublishSubject<DeliveryLocation> = .init()
    private let viewModel: DeliveryLocationMapViewModel
    private let disposeBag = DisposeBag()
    private let userLocationStatusSubject: PublishSubject<UserLocationStatus> = .init()
    
    let points = LocationArea().location
    
    let lines = [
        CLLocationCoordinate2D(latitude: 42.271008, longitude: 69.558747),
        CLLocationCoordinate2D(latitude: 42.382227, longitude: 69.491084),
        CLLocationCoordinate2D(latitude: 42.410608, longitude: 69.636103),
        CLLocationCoordinate2D(latitude: 42.311006, longitude: 69.660448)
    ]
    
    private let locationManager = CLLocationManager()
    private let secondManager = CLLocationManager()
    private let mapManager: MapManager<YandexMapViewModel>
    override func loadView() {
        view = DeliveryLocationMapView()
    }
    
    init(viewModel: DeliveryLocationMapViewModel, mapManager: MapManager<YandexMapViewModel>) {
        self.viewModel = viewModel
        self.mapManager = mapManager
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
        deliveryZone()
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
        let newPoint: [YMKPoint] = points.map { YMKPoint(latitude: $0.longitude, longitude: $0.latitude) }

        let polygonCoordinates: [CLLocationCoordinate2D] = newPoint.map { CLLocationCoordinate2D(latitude: $0.latitude, longitude: $0.longitude)}
        let deliveryPolygon = MKPolygon(coordinates: polygonCoordinates, count: polygonCoordinates.count)
        
        rootView.saveButton.rx.tap
            .withLatestFrom(deliveryLocationObject)
            .subscribe(onNext: { [unowned self] location in
                let deliveryCoordinate = CLLocationCoordinate2D(latitude: location.point.latitude, longitude: location.point.longitude)
                let isOnRegion = deliveryPolygon.contain(coor: deliveryCoordinate)
                if isOnRegion {
                    self.saveLocationToCache(location: location)
                    self.onlocationDidSelect?(location)
                } else {
                    self.showErrorInAlert(text: "К сожалению, доставка работает только в черте города Шымкент")
                }
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
        
        rootView.currentLocationButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.moveToMyLocation()
            }).disposed(by: disposeBag)
    }
    
    private func moveToMyLocation() {
        if let coordinate = secondManager.location?.coordinate {
            let viewModel = MapTransitionViewModel(duration: 0.1, animationType: .smooth, zoom: 18)
            mapManager.moveTo(in: rootView.mapView, point: MapPoint(latitude: coordinate.latitude, longitude: coordinate.longitude), transitionViewModel: viewModel)
        }
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
    
    
    private func deliveryZone() {
        let newPoint: [YMKPoint] = points.map { YMKPoint(latitude: $0.longitude, longitude: $0.latitude) }
        let addPolygon = YMKPolygon(outerRing: YMKLinearRing(points: newPoint), innerRings: [])
        
        let mapObjects = rootView.mapView.mapWindow.map.mapObjects.addPolygon(with: addPolygon)
        
        mapObjects.strokeColor = .primary
        mapObjects.strokeWidth = 3
        mapObjects.fillColor = UIColor.primary.withAlphaComponent(0.1)
    }
    
    func getLocationSucces(deliveryLocation: YMKPoint) -> Bool {
        if let userCoordinate = locationManager.location?.coordinate {
            let distance = YMKDistance(YMKPoint(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude), deliveryLocation)
            return distance < 11000
        } else {
            return false
        }
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

extension CLLocationCoordinate2D {

    func liesInsideRegion(region: [CLLocationCoordinate2D]) -> Bool {
        var liesInside = false
        var i = 0
        var j = region.count-1

        while i < region.count {

            let iCoordinate = region[i]
            let jCoordinate = region[j]

            if (iCoordinate.latitude > self.latitude) != (jCoordinate.latitude > self.latitude) {
                if self.longitude < (iCoordinate.longitude - jCoordinate.longitude) * (self.latitude - iCoordinate.latitude) / (jCoordinate.latitude-iCoordinate.latitude) + iCoordinate.longitude {
                    liesInside = !liesInside
                    }
            }

            i += 1
            j = i+1
        }
        return liesInside
    }

}

extension MKPolygon {
    func contain(coor: CLLocationCoordinate2D) -> Bool {
        let polygonRenderer = MKPolygonRenderer(polygon: self)
        let currentMapPoint: MKMapPoint = MKMapPoint(coor)
        let polygonViewPoint: CGPoint = polygonRenderer.point(for: currentMapPoint)
        if polygonRenderer.path == nil {
          return false
        }else{
          return polygonRenderer.path.contains(polygonViewPoint)
        }
    }
}
