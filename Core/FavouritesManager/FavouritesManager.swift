import RxSwift

final class FavouritesManager {
    private let apiService: ApiService
    private let userInfoStorage: UserInfoStorage
    private let disposeBag = DisposeBag()
    
    init(apiService: ApiService, userInfoStorage: UserInfoStorage) {
        self.apiService = apiService
        self.userInfoStorage = userInfoStorage
    }
    
    func getIsFavourite(id: Int) -> Bool {
        return userInfoStorage.favouriteIds.contains(id)
    }
    
    func saveToFavourite(id: Int, completion: @escaping(()->Void)) {
        let status = userInfoStorage.favouriteIds.contains(id)
        let statusId = status == true ? 0 : 1
        apiService.makeRequest(to: FavoritesTarget.changeFavoriteStatus(retail: .init(id: id, status: statusId)))
            .run()
            .subscribe(onNext: { [unowned self] data in
                if status {
                    if let index = userInfoStorage.favouriteIds.firstIndex(of: id) {
                        self.userInfoStorage.favouriteIds.remove(at: index)
                        completion()
                    }
                } else {
                    self.userInfoStorage.favouriteIds.append(id)
                    completion()
                }
            })
            .disposed(by: disposeBag)
    }

    func getFavouriteIds() {
        apiService.makeRequest(to: FavoritesTarget.getFavoriteRetails(type: 1))
            .result(DeliveryRetailList.self)
            .subscribe(onNext: { [unowned self] retails in
                let ids = retails.items.map { $0.id }
                self.userInfoStorage.favouriteIds = ids
            }).disposed(by: disposeBag)
    }
}
