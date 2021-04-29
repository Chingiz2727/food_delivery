import RxSwift

final class DeliveryRetailListViewModel: ViewModel {
    lazy var adapter = PaginationAdapter(manager: manager)

    private lazy var manager = PaginationManager<DeliveryRetailList> { [unowned self] page, pageSize, _ in
        return self.apiService.makeRequest(
            to: DeliveryApiTarget.deliveryRetailListByType(page: page, size: pageSize, type: 1)
        )
        .result()
    }
    
    private let apiService: ApiService
    private let disposeBag = DisposeBag()

    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    struct Input {
        let loadRetailList: Observable<Void>
    }

    struct Output {
        let retailList: Observable<LoadingSequence<[DeliveryRetail]>>
        let activeOrders: Observable<LoadingSequence<ActiveOrders>>
    }

    func transform(input: Input) -> Output {
        input.loadRetailList
            .subscribe(onNext: { [unowned self] in
                self.manager.resetData()
            })
            .disposed(by: disposeBag)
        let activeOrders = input.loadRetailList
            .flatMap { [unowned self] in
                return self.apiService.makeRequest(to: MakeOrderTarget.getActiveOrders)
                    .result(ActiveOrders.self)
                    .asLoadingSequence()
            }.share()
        
        return .init(retailList: manager.contentUpdate.asLoadingSequence(), activeOrders: activeOrders)
    }
}
