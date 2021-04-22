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
    private let utensils = 0
    private let cardId = 32

    let mapManager: MapManager<YandexMapViewModel>
    var orderType: Int = 0
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
        let addAmount: Observable<Int>
        let description: Observable<String>
        let fullAmount: Observable<Int>
        let userLocation: Observable<DeliveryLocation>
        let foodAmount: Observable<Int>
        let useCashback: Observable<Bool>
        let deliveryAmount: Observable<Int>
        let makeOrderTapped: Observable<Void>
    }

    struct Output {
        let savedLocationList: Observable<[DeliveryLocation]>
        let deliveryDistance: Observable<Double>
        let currentLocationName: Observable<DeliveryLocation>
        let deliveryRate: Observable<LoadingSequence<DeliveryRate>>
        let orderResponse: Observable<LoadingSequence<OrderResponse>>
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

        let orderResponse = input.makeOrderTapped
            .withLatestFrom(Observable<Any>.combineLatest(input.addAmount, input.description, input.fullAmount, input.userLocation, input.foodAmount, input.deliveryAmount, input.useCashback))
            .flatMap { [unowned self] addAmount, description, fullAmount, userLocation, foodAmount, deliveryAmount, useCashback in
                apiService.makeRequest(
                    to: MakeOrderTarget.makeOrder(
                        addAmount: addAmount,
                        address: userLocation.name,
                        contactless: 1,
                        deliveryAmount: deliveryAmount,
                        description: description,
                        foodAmount: foodAmount,
                        fullAmount: fullAmount,
                        latitude: userLocation.point.latitude,
                        longitude: userLocation.point.longitude,
                        orderItems: dishList.products,
                        retailId: dishList.retail?.id ?? 0,
                        type: orderType,
                        useCashback: useCashback,
                        utensils: utensils,
                        cardId: cardId))
                    .result(OrderResponse.self).asLoadingSequence()
            }.share()

        return .init(
            savedLocationList: savedLocations,
            deliveryDistance: distance,
            currentLocationName: location,
            deliveryRate: deliveryRate,
            orderResponse: orderResponse)
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
