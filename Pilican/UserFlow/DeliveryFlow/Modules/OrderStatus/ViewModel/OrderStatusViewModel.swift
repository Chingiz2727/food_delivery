import RxSwift


final class OrderStatusViewModel: ViewModel {
    
    let orderResponse: DeliveryOrderResponse
    private let apiService: ApiService
    private let disposeBag = DisposeBag()
    
    init(apiService: ApiService, orderResponse: DeliveryOrderResponse) {
        self.apiService = apiService
        self.orderResponse = orderResponse
    }
    
    struct Input {
        let loadView: Observable<Void>
    }
    
    struct Output {
        let status: Observable<LoadingSequence<ProductDeliveryStatus>>
    }
    
    func transform(input: Input) -> Output {
        let status = input.loadView
            .flatMap { [unowned self] in
                return self.apiService.makeRequest(to: MakeOrderTarget.getFindOrderById(id: self.orderResponse.id ?? 0))
                    .result(ProductDeliveryStatus.self)
                    .asLoadingSequence()
            }
        return .init(status: status)
    }
}
