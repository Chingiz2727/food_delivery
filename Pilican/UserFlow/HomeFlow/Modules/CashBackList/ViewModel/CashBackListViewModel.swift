import RxSwift

final class CashBackListViewModel: ViewModel {
    lazy var adapter = PaginationAdapter(manager: manager)

    private lazy var manager = PaginationManager<RetailList> { [unowned self] page, pageSize, _ in
        return self.apiService.makeRequest(
            to: HomeApiTarget.fullPaginatedRetailList(
                pageNumber: page, cityId: nil, size: pageSize, categoryId: self.categoryId, name: "")
        )
        .result()
    }

    private let apiService: ApiService
    private let disposeBag = DisposeBag()
    private var categoryId: Int = 1

    init(apiService: ApiService) {
        self.apiService = apiService
        self.categoryId = 1
    }
    
    struct Input {
        let loadByCategoryId: Observable<Int>
    }

    struct Output {
        let retailList: Observable<LoadingSequence<[Retail]>>
    }

    func transform(input: Input) -> Output {
        input.loadByCategoryId
            .subscribe(onNext: { [unowned self] id in
                self.categoryId = id
                self.manager.resetData()
            })
            .disposed(by: disposeBag)
        return .init(retailList: self.manager.contentUpdate.asLoadingSequence().share())
    }
}
