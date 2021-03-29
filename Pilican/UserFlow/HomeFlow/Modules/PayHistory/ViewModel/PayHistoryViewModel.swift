//
//  PayHistoryViewModel.swift
//  Pilican
//
//  Created by kairzhan on 3/17/21.
//

import RxSwift

final class PayHistoryViewModel: ViewModel {
    
    lazy var adapter = PaginationAdapter(manager: manager)
    
    private lazy var manager = PaginationManager<PaymentHistoryResponse> { [ unowned self] page, _, _ in
        return self.apiService.makeRequest(
            to: PayHistoryTarget.getPayHistory(pageNumber: page))
            .result()
    }
    
    private let apiService: ApiService
    private let disposeBag = DisposeBag()
    
    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    struct Input {
        let loadPayHistory: Observable<Void>
    }

    struct Output {
        let payHistory: Observable<LoadingSequence<[Payments]>>
    }

    func transform(input: Input) -> Output {
        input.loadPayHistory
            .subscribe(onNext: { [unowned self] _ in
                self.manager.resetData()
            }).disposed(by: disposeBag)
        return .init(payHistory: self.manager.contentUpdate.asLoadingSequence())
    }
}
