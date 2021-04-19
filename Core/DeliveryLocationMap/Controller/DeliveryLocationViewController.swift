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
        viewModel.mapManager.setupCameraListener(in: rootView.mapView)
        bindViewModel()
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: .init(text: rootView.textField.rx.text.unwrap()))
        
        let locationArray = output.locationArray.share()
        let location = output.locationName.share()
        location.subscribe(onNext: { [unowned self] location in
            self.rootView.textField.text = location.name
            self.deliveryLocationObject.onNext(location)
        }).disposed(by: disposeBag)
        
        rootView.saveButton.rx.tap
            .withLatestFrom(deliveryLocationObject)
            .subscribe(onNext: { [unowned self] location in
                self.onlocationDidSelect?(location)
            })
            .disposed(by: disposeBag)
        guard let userCoordinate = locationManager.location?.coordinate else { return }
        viewModel.mapManager.showCurrentLocation(in: rootView.mapView)
        viewModel.mapManager.moveTo(in: rootView.mapView, point: MapPoint(latitude: userCoordinate.latitude, longitude: userCoordinate.longitude), transitionViewModel: .init(duration: 0.3, animationType: .linear, zoom: 12))
    }
}
