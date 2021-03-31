import RxSwift

final class DeliveryRetailProductViewModel: ViewModel {
    let retailInfo: DeliveryRetail

    private let apiService: ApiService
    
    init(apiService: ApiService, retailInfo: DeliveryRetail) {
        self.apiService = apiService
        self.retailInfo = retailInfo
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
}
