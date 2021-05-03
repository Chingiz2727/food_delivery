import RxSwift

protocol UserInfoUpdater {
    func updateUserBalance()
}

final class UserInfoUpdaterImpl: UserInfoUpdater {
    private let apiService: ApiService
    private let userSession: UserSessionStorage
    private let appSession: AppSessionManager
    private let disposeBag = DisposeBag()
    private let userInfo: UserInfoStorage

    init(apiService: ApiService, userSession: UserSessionStorage, appSession: AppSessionManager, userInfo: UserInfoStorage) {
        self.apiService = apiService
        self.userSession = userSession
        self.appSession = appSession
        self.userInfo = userInfo
    }
    
    func updateUserBalance() {
        self.apiService.makeRequest(to: AddCardApiTarget.cardList(cardName: ""))
            .result(CardList.self)
            .subscribe(onNext: { [unowned self] card in
                self.userInfo.balance = card.balance
                self.userInfo.updateInfo.onNext(())
            })
            .disposed(by: disposeBag)
    }
}
