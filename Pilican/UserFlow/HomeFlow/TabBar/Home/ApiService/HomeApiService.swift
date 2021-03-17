import RxSwift
import RxRelay

protocol HomeApiService {
    func fetchSliders() -> Observable<LoadingSequence<Sliders>>
    func fetchNewCompaniesList() -> Observable<LoadingSequence<RetailList>>
}

final class HomeApiServiceImpl: HomeApiService {
    private let apiService: ApiService

    init(apiService: ApiService) {
        self.apiService = apiService
    }

    func fetchSliders() -> Observable<LoadingSequence<Sliders>> {
        let sliders = apiService.makeRequest(to: HomeApiTarget.slider)
            .result(Sliders.self)
            .asLoadingSequence()
        return sliders
    }

    func fetchNewCompaniesList() -> Observable<LoadingSequence<RetailList>> {
        let companyList = apiService.makeRequest(to: HomeApiTarget.retailList)
            .result(RetailList.self)
            .asLoadingSequence()
        return companyList
    }
}
