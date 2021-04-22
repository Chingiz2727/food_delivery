import RxSwift

final class DeliveryRetailProductViewModel: ViewModel {

    let retailInfo: DeliveryRetail
    let dishList: DishList
    private let apiService: ApiService

    init(apiService: ApiService, retailInfo: DeliveryRetail, dishList: DishList) {
        self.apiService = apiService
        self.retailInfo = retailInfo
        self.dishList = dishList
        self.dishList.retail = retailInfo
    }

    struct Input {
        let viewDidLoad: Observable<Void>
        let favoriteButtonTapped: Observable<Void>
    }

    struct Output {
        let productsList: Observable<LoadingSequence<ProductList>>
        let favoriteButtonTapped: Observable<LoadingSequence<ResponseStatus>>
    }

    func transform(input: Input) -> Output {
        let productsList = input.viewDidLoad
            .flatMap { [unowned self] in
                return self.apiService.makeRequest(to: DeliveryApiTarget.deliveryRetailProductsList(retailId: self.retailInfo.id))
                    .result(ProductList.self)
            }.asLoadingSequence()
        let favoriteButtonTapped = input.favoriteButtonTapped
            .flatMap { [unowned self] in
                return self.apiService.makeRequest(
                    to: FavoritesTarget.changeFavoriteStatus(
                        retail: .init(
                            id: retailInfo.id,
                            status: 1)))
                    .result(ResponseStatus.self)
            }.asLoadingSequence()
        return .init(productsList: productsList, favoriteButtonTapped: favoriteButtonTapped)
    }
}
