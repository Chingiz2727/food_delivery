import RxSwift

final class CashBackListViewModel: ViewModel {
    lazy var adapter = PaginationAdapter(manager: manager)
    private let apiService: ApiService
    private let manager: PaginationManager<RetailList>
    private let disposeBag = DisposeBag()

    init(apiService: ApiService) {
        self.apiService = apiService
        self.manager = PaginationManager(
            pageSize: 15, shouldLoadOnEmptyQuery: true, requestFabric: { page, pageSize, _ in
            return apiService.makeRequest(
                to: HomeApiTarget.fullPaginatedRetailList(
                    pageNumber: page, cityId: nil, size: pageSize, categoryId: nil, name: ""
                )
            ).result()
            }
        )
    }
    
    struct Input {
        let loadView: Observable<Void>
    }

    struct Output {
        let retailList: Observable<LoadingSequence<[Retail]>>
    }

    func transform(input: Input) -> Output {
        input.loadView
            .subscribe(onNext: { [unowned self] in
                self.manager.resetData()
            })
            .disposed(by: disposeBag)
    
        return .init(retailList: self.manager.contentUpdate.asLoadingSequence())
    }
}
