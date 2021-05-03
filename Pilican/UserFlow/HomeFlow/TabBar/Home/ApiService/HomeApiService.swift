import RxSwift
import RxRelay

protocol HomeApiService {
    func fetchSliders() -> Observable<LoadingSequence<Sliders>>
    func fetchNewCompaniesList() -> Observable<LoadingSequence<RetailList>>
    func sendFiretoken() -> Observable<LoadingSequence<Data>>
}

final class HomeApiServiceImpl: HomeApiService {
    private let apiService: ApiService
    private let appSession: AppSessionManager

    init(apiService: ApiService, appSession: AppSessionManager ) {
        self.apiService = apiService
        self.appSession = appSession
    }

    func fetchSliders() -> Observable<LoadingSequence<Sliders>> {
        let sliders = apiService.makeRequest(to: HomeApiTarget.slider)
            .result(Sliders.self)
            .asLoadingSequence()
        return sliders
    }

    func fetchNewCompaniesList() -> Observable<LoadingSequence<RetailList>> {
        let companyList = apiService.makeRequest(to: HomeApiTarget.retailList(pageNumber: 0, size: 10))
            .result(RetailList.self)
            .asLoadingSequence()
        return companyList
    }
    
    func sendFiretoken() -> Observable<LoadingSequence<Data>> {
        return apiService.makeRequest(to: HomeApiTarget.fireBaseToken(token: appSession.pushNotificationToken ?? ""))
            .run()
            .asLoadingSequence()
    }
}
