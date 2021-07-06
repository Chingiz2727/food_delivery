import RxSwift
import YandexMapsMobile

final class DeliveryLocationMapViewModel: ViewModel {
    let mapManager: MapManager<YandexMapViewModel>
    let userInfoStorage: UserInfoStorage
    private var searchManager: YMKSearchManager?
    private var searchSession: YMKSearchSession?
    private let location: PublishSubject<DeliveryLocation> = .init()
    private let locationArray: PublishSubject<[DeliveryLocation]> = .init()
    private let disposeBag = DisposeBag()
    private let apiService = assembler.resolver.resolve(ApiService.self)!
    private let cache = DiskCache<String, [DeliveryLocation]>()

    init(mapManager: MapManager<YandexMapViewModel>, userInfoStorage: UserInfoStorage) {
        self.mapManager = mapManager
        self.userInfoStorage = userInfoStorage
    }
    
    struct Input {
        let text: Observable<String>
        let loadLocations: Observable<Void>
    }
    
    struct Output {
        let locationName: Observable<DeliveryLocation>
        let locationArray: Observable<[DeliveryLocation]>
        let locationData: Observable<LoadingSequence<DeliveryLocationArea>>
    }
    
    func transform(input: Input) -> Output {
        searchManager = YMKSearch.sharedInstance().createSearchManager(with: .combined)

        mapManager.onCameraPositionChanged = { [unowned self] mapPoint, finished in
            guard let mapPoint = mapPoint else  { return }
            if finished {
                self.searchByCameraLocation(mapPoint: mapPoint)
            }
        }
        
        input.text
            .subscribe(onNext: { [unowned self] text in
                if !text.isEmpty {
                    self.searchByText(text: text)
                }
            })
            .disposed(by: disposeBag)

        let locationArea = input.loadLocations
            .flatMap { [unowned self] in
                return self.apiService.makeRequest(to: MapApiTarget.getPolylines)
                    .result(DeliveryLocationArea.self)
                    .asLoadingSequence()
            }
        
        return .init(locationName: location, locationArray: locationArray, locationData: locationArea)
    }
    
    func saveAdress(adress: DeliveryLocation) {
        var cacheaddress = getAddress() ?? []

        if cacheaddress.count > 4 {
            cacheaddress.removeFirst(1)
        }
        cacheaddress.append(adress)
        removeAddress()
        saveAddress(address: cacheaddress)
    }

    private func searchByCameraLocation(mapPoint: MapPoint) {
        let options = YMKSearchOptions()
        options.geometry = true
        searchSession = searchManager?.submit(with: YMKPoint(latitude: mapPoint.latitude, longitude: mapPoint.longitude), zoom: 18, searchOptions: options, responseHandler: { [unowned self] (res, err) in
            if let name = res?.collection.children[0].obj?.name, let coordinate = res?.collection.children[0].obj?.geometry[0].point {
                let deliveryLocation = DeliveryLocation(point: MapPoint(latitude: coordinate.latitude, longitude: coordinate.longitude), name: name)
                self.location.onNext(deliveryLocation)
            }
        })
    }
    
    private func searchByText(text: String) {
        let options = YMKSearchOptions()
        options.geometry = true
        searchSession = searchManager?.submit(withText: text, polyline: Constants.ShymkentPolyLine, geometry: .init(polyline: Constants.ShymkentPolyLine), searchOptions: options, responseHandler: { [unowned self] (response, error) in
            guard let collection = response?.collection.children else { return }
            let locationArray: [DeliveryLocation] = collection.map { object in
                let name = object.obj?.name
                let coordinate = object.obj?.geometry[0].point
                return .init(point: MapPoint(latitude: coordinate?.latitude ?? 0, longitude: coordinate?.longitude ?? 0), name: name ?? "")
            }
            self.locationArray.onNext(locationArray)
        })
    }
    
    private func getAddress() -> [DeliveryLocation]? {
        let address: [DeliveryLocation]? = try? self.cache.readFromDisk(name: "adressList")
        return address
    }
    
    private func saveAddress(address: [DeliveryLocation]){
        if getAddress() == nil {
            try? cache.saveToDisk(name: "adressList", value: address)
        }
    }
    
    private func removeAddress() {
        try? cache.clearFromDisk(name: "adressList")
    }
}

private enum Constants {
    static let ShymkentPolyLine = YMKPolyline(
        points: [
            YMKPoint(latitude: 42.271008, longitude: 69.558747),
            YMKPoint(latitude: 42.382227, longitude: 69.491084),
            YMKPoint(latitude: 42.410608, longitude: 69.636103),
            YMKPoint(latitude: 42.311006, longitude: 69.660448)
        ]
    )
}
