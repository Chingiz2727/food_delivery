import RxSwift

final class DeliveryTabBarViewModel: ViewModel {
    private let apiService: ApiService
    
    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    struct Input {
        let viewDidLoad: Observable<Void>
    }
    
    struct Output {
        let activeOrders: Observable<LoadingSequence<ActiveOrders>>
    }
    
    func transform(input: Input) -> Output {
        let activeOrders = input.viewDidLoad
            .flatMap { [unowned self] in
                return self.apiService.makeRequest(to: MakeOrderTarget.getActiveOrders)
                    .result(ActiveOrders.self)
                    .asLoadingSequence()
            }.share()
        return .init(activeOrders: activeOrders)
    }
}
