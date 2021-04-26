import RxSwift

final class DeliveryRetailProductViewModel: ViewModel {

    let retailInfo: DeliveryRetail
    let dishList: DishList
    private let apiService: ApiService
    private let cache = DiskCache<String, [DeliveryRetail]>()
    private var status = 1

    init(apiService: ApiService, retailInfo: DeliveryRetail, dishList: DishList) {
        self.apiService = apiService
        self.retailInfo = retailInfo
        self.dishList = dishList
        self.dishList.retail = retailInfo
        let favorites = getFavorites()
        favorites?.forEach { retail in
            if retail.id == retailInfo.id {
                status = 0
            }
        }
    }

    struct Input {
        let viewDidLoad: Observable<Void>
        let favoriteButtonTapped: Observable<Void>
        let loadFavorites: Observable<Void>
    }

    struct Output {
        let productsList: Observable<LoadingSequence<ProductList>>
        let favoriteButtonTapped: Observable<LoadingSequence<ResponseStatus>>
        let favorites: Observable<LoadingSequence<DeliveryRetailList>>
    }

    func transform(input: Input) -> Output {
        let productsList = input.viewDidLoad
            .flatMap { [unowned self] in
                return self.apiService.makeRequest(to: DeliveryApiTarget.deliveryRetailProductsList(retailId: self.retailInfo.id))
                    .result(ProductList.self)
            }.asLoadingSequence()
        let favorites = input.loadFavorites
            .flatMap { [unowned self] in
                return self.apiService.makeRequest(to: FavoritesTarget.getFavoriteRetails(type: 1))
                    .result(DeliveryRetailList.self)
            }.asLoadingSequence()
        let favoriteButtonTapped = input.favoriteButtonTapped
            .flatMap { [unowned self] in
                return self.apiService.makeRequest(
                    to: FavoritesTarget.changeFavoriteStatus(
                        retail: .init(
                            id: retailInfo.id,
                            status: status)))
                    .result(ResponseStatus.self)
            }.asLoadingSequence()
        return .init(productsList: productsList, favoriteButtonTapped: favoriteButtonTapped, favorites: favorites)
    }

    private func getFavorites() -> [DeliveryRetail]? {
        let favorites: [DeliveryRetail]? = try? cache.readFromDisk(name: "favorites")
        return favorites
    }
}
