import RxSwift

final class HomeViewModel: ViewModel {
    private let disposeBag = DisposeBag()

    struct Input {
        let viewDidLoad: Observable<Void>
        let searchText: Observable<String>
    }

    struct Output {
        let retailList: Observable<LoadingSequence<RetailList>>
        let slider: Observable<LoadingSequence<Sliders>>
        let searchRetailList: Observable<LoadingSequence<RetailList>>
    }

    private let apiService: HomeApiService
    
    init(apiService: ApiService, appSession: AppSessionManager) {
        self.apiService = HomeApiServiceImpl(apiService: apiService, appSession: appSession)
    }

    func transform(input: Input) -> Output {
        let slider = input.viewDidLoad
            .flatMap { [unowned self] in
                return apiService.fetchSliders()
            }.share()

        let retailList = input.viewDidLoad
            .flatMap { [unowned self] in
                return apiService.fetchNewCompaniesList()
            }.share()
        

        let token = apiService.sendFiretoken().publish()
        
            token
            .subscribe(onNext: { _ in })
            .disposed(by: disposeBag)
        
        token.connect()
            .disposed(by: disposeBag)
        
        let searchRetailList = input.searchText
            .flatMap { [unowned self] text in
                return apiService.searchRetailList(name: text)
            }.share()
        
        return .init(retailList: retailList, slider: slider, searchRetailList: searchRetailList)
    }
}
