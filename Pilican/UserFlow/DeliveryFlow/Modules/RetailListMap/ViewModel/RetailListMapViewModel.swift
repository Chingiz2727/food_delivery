import RxSwift

final class RetailListMapViewModel: ViewModel {
    
    private let apiService: ApiService
    
    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    struct Input {
        let coordinates: Observable<MapPoint>
    }
    
    struct Output {
        let retailList: Observable<LoadingSequence<MapRetail>>
    }
    
    func transform(input: Input) -> Output {
        let retailList = input.coordinates
            .flatMap { [unowned self] coordinate in
                return self.apiService.makeRequest(to: RetailListMapTarget.getNearRetail(lat: coordinate.latitude, long: coordinate.longitude))
                    .result(MapRetail.self)
            }.asLoadingSequence()
            .share()
        return .init(retailList: retailList)
    }
}
