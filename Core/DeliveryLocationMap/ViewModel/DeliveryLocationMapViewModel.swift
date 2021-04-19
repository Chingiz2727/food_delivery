import RxSwift
import YandexMapsMobile

final class DeliveryLocationMapViewModel: ViewModel {
    let mapManager: MapManager<YandexMapViewModel>
    private var searchManager: YMKSearchManager?
    private var searchSession: YMKSearchSession?
    private let location: PublishSubject<DeliveryLocation> = .init()
    private let locationArray: PublishSubject<[DeliveryLocation]> = .init()
    private let disposeBag = DisposeBag()
    
    init(mapManager: MapManager<YandexMapViewModel>) {
        self.mapManager = mapManager
    }
    
    struct Input {
        let text: Observable<String>
    }
    
    struct Output {
        let locationName: Observable<DeliveryLocation>
        let locationArray: Observable<[DeliveryLocation]>
    }
    
    func transform(input: Input) -> Output {
        searchManager = YMKSearch.sharedInstance().createSearchManager(with: .combined)

        mapManager.onCameraPositionChanged = { [unowned self] mapPoint in
            guard let mapPoint = mapPoint else  { return }
            self.searchByCameraLocation(mapPoint: mapPoint)
        }
        
        input.text
            .subscribe(onNext: { [unowned self] text in
                self.searchByText(text: text)
            })
            .disposed(by: disposeBag)

        return .init(locationName: location, locationArray: locationArray)
    }
    
    private func searchByCameraLocation(mapPoint: MapPoint) {
        searchSession = searchManager?.submit(with: YMKPoint(latitude: mapPoint.latitude, longitude: mapPoint.longitude), zoom: 18, searchOptions: YMKSearchOptions.init(), responseHandler: { [unowned self] (res, err) in
            if let name = res?.collection.children[0].obj?.name, let coordinate = res?.collection.children[0].obj?.geometry[0].point {
                let deliveryLocation = DeliveryLocation(point: MapPoint(latitude: coordinate.latitude, longitude: coordinate.longitude), name: name)
                self.location.onNext(deliveryLocation)
            }
        })
    }
    
    private func searchByText(text: String) {
        searchSession = searchManager?.submit(withText: text, polyline: Constants.ShymkentPolyLine, geometry: .init(polyline: Constants.ShymkentPolyLine), searchOptions: YMKSearchOptions(), responseHandler: { [unowned self] (response, error) in
            guard let collection = response?.collection.children else { return }
            let locationArray: [DeliveryLocation] = collection.map { object in
                let name = object.obj?.name
                let coordinate = object.obj?.geometry[0].point
                return .init(point: MapPoint(latitude: coordinate?.latitude ?? 0, longitude: coordinate?.longitude ?? 0), name: name ?? "")
            }
            self.locationArray.onNext(locationArray)
        })
    }
}

private enum Constants {
    static let ShymkentPolyLine = YMKPolyline(
        points: [
            YMKPoint(latitude: 42.34517891311695, longitude: 69.50908088183532),
            YMKPoint(latitude: 42.380313451969386, longitude: 69.52470206713805),
            YMKPoint(latitude: 42.387921232511964, longitude: 69.55165290331969),
            YMKPoint(latitude: 42.38373706729813, longitude: 69.58255195117125),
            YMKPoint(latitude: 42.38373706729813, longitude: 69.60315131640563),
            YMKPoint(latitude: 42.384624640798584, longitude: 69.62993049121032),
            YMKPoint(latitude: 42.38849177888856, longitude: 42.38849177888856),
            YMKPoint(latitude: 42.38563899514845, longitude: 69.66134452319274),
            YMKPoint(latitude: 42.36198759693794, longitude: 69.73112487292418),
            YMKPoint(latitude: 42.31424553666617, longitude: 69.67160129046569),
            YMKPoint(latitude: 42.30912816615637, longitude: 69.65521835780272),
            YMKPoint(latitude: 42.29943972549621, longitude: 69.64467191195617),
            YMKPoint(latitude: 42.282090439438065, longitude: 69.67267417407164),
            YMKPoint(latitude: 42.27237402217843, longitude: 69.61491012072692),
            YMKPoint(latitude: 69.61491012072692, longitude: 69.57225226855407),
            YMKPoint(latitude: 42.30729533227581, longitude: 69.55366992449889),
            YMKPoint(latitude: 42.319418021668206, longitude: 69.53834914660582),
        ]
    )
}
