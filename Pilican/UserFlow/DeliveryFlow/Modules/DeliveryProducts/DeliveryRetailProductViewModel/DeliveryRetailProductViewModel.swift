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
    }

    struct Output {
        let productsList: Observable<LoadingSequence<ProductList>>
    }

    func transform(input: Input) -> Output {
        let productsList = input.viewDidLoad
            .flatMap { [unowned self] in
                return self.apiService.makeRequest(to: DeliveryApiTarget.deliveryRetailProductsList(retailId: self.retailInfo.id))
                    .result(ProductList.self)
            }.asLoadingSequence()
        return .init(productsList: productsList)
    }

    private func getFavorites() -> [DeliveryRetail]? {
        let favorites: [DeliveryRetail]? = try? cache.readFromDisk(name: "favorites")
        return favorites
    }
}
