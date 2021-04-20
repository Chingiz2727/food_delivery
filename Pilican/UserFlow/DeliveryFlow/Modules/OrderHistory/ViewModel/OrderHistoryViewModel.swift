//
//  OrderHistoryViewModel.swift
//  Pilican
//
//  Created by kairzhan on 4/17/21.
//

import RxSwift

final class OrderHistoryViewModel: ViewModel {
    lazy var adapter = PaginationAdapter(manager: manager)
    
    private lazy var manager = PaginationManager<OrderHistoryResponse> { [unowned self] page, _, _ in
        return self.apiService.makeRequest(to: OrderHistoryTarget.getOrderHistory(pageNumber: page))
            .result()
    }
    
    private let apiService: ApiService
    private let disposeBag = DisposeBag()
    
    init(apiService: ApiService) {
        self.apiService = apiService
    }

    struct Input {
        let loadOrderHistory: Observable<Void>
    }

    struct Output {
        let payHistory: Observable<LoadingSequence<[DeliveryOrderResponse]>>
    }

    func transform(input: Input) -> Output {
        input.loadOrderHistory
            .subscribe(onNext: { [unowned self] _ in
                self.manager.resetData()
            }).disposed(by: disposeBag)
        return .init(payHistory: self.manager.contentUpdate.asLoadingSequence())
    }
}
