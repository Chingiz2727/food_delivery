import RxSwift

final class OrderStatusViewModel: ViewModel {
    
    let orderId: Int
    private let apiService: ApiService
    private let disposeBag = DisposeBag()
    
    init(apiService: ApiService, orderId: Int) {
        self.apiService = apiService
        self.orderId = orderId
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
                return self.apiService.makeRequest(to: MakeOrderTarget.getFindOrderById(id: self.orderId))
                    .result(ProductDeliveryStatus.self)
                    .asLoadingSequence()
            }
        return .init(status: status)
    }
}
