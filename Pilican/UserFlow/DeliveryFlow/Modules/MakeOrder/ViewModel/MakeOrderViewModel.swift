import RxSwift
import YandexMapsMobile

final class MakeOrderViewModel: ViewModel {
    
    let dishList: DishList
    let userInfo: UserInfoStorage
    
    private var searchManager: YMKSearchManager?
    private var searchSession: YMKSearchSession?
    private let apiService: ApiService
    private let cache = DiskCache<String, [DeliveryLocation]>()
    private let disposeBag = DisposeBag()
    
    let mapManager: MapManager<YandexMapViewModel>

    let location: PublishSubject<DeliveryLocation> = .init()

    init(dishList: DishList, userInfo: UserInfoStorage, mapManager: MapManager<YandexMapViewModel>, apiService: ApiService) {
        self.dishList = dishList
        self.userInfo = userInfo
        self.mapManager = mapManager
        self.apiService = apiService
    }
    
    struct Input {
        let showLocationList: Observable<Void>
        let currentLocation: Observable<DeliveryLocation>
    }
    
    struct Output {
        let savedLocationList: Observable<[DeliveryLocation]>
        let deliveryDistance: Observable<Double>
        let currentLocationName: Observable<DeliveryLocation>
        let deliveryRate: Observable<LoadingSequence<DeliveryRate>>
    }
    
    func transform(input: Input) -> Output {
        searchManager = YMKSearch.sharedInstance().createSearchManager(with: .combined)

        let distance = input.currentLocation
            .flatMap { [unowned self] location -> Observable<Double> in
                let firstPoint = MapPoint(latitude: self.dishList.retail?.latitude ?? 0, longitude: self.dishList.retail?.longitude ?? 0)
                return .just(self.mapManager.getDistance(firstPoint: firstPoint, secondPoint: MapPoint(latitude: location.point.latitude, longitude: location.point.longitude)))
            }
        
        let savedLocations = input.showLocationList
            .flatMap { [unowned self] _ -> Observable<[DeliveryLocation]> in
                return .just(getAddress())
            }
        
        input.currentLocation
            .subscribe(onNext: { [unowned self] mapPoint in
                self.searchByLocation(mapPoint: mapPoint.point)
            }).disposed(by: disposeBag)
    
        let deliveryRate = distance.flatMap { [unowned self] distance -> Observable<DeliveryRate> in
            return self.apiService.makeRequest(to: MakeOrderTarget.deliveryDistance(km: distance / 1000))
                .result(DeliveryRate.self)
        }.asLoadingSequence()
    
        return .init(
            savedLocationList: savedLocations,
            deliveryDistance: distance,
            currentLocationName: location,
            deliveryRate: deliveryRate)
    }

    private func getAddress() -> [DeliveryLocation] {
        let address: [DeliveryLocation]? = try? self.cache.readFromDisk(name: "adressList")
        return address ?? []
    }

    private func searchByLocation(mapPoint: MapPoint) {
        let options = YMKSearchOptions()
        options.geometry = true
        // swiftlint:disable line_length
        searchSession = searchManager?.submit(with: YMKPoint(latitude: mapPoint.latitude, longitude: mapPoint.longitude), zoom: 18, searchOptions: options, responseHandler: { [unowned self] (res, err) in
            if let name = res?.collection.children[0].obj?.name, let coordinate = res?.collection.children[0].obj?.geometry[0].point {
                let deliveryLocation = DeliveryLocation(point: MapPoint(latitude: coordinate.latitude, longitude: coordinate.longitude), name: name)
                self.location.onNext(deliveryLocation)
            }
        })
    }
}
