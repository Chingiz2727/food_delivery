//
//  CreateOrderRatingsViewModel.swift
//  Pilican
//
//  Created by kairzhan on 4/30/21.
//

import RxSwift

final class CreateOrderRatingsViewModel: ViewModel {

    struct Input {
        let ratingSelected: Observable<Int>
        let ratingValue: Observable<Int>
    }

    struct Output {
        let result: Observable<LoadingSequence<ResponseStatus>>
    }

    private let apiService: ApiService
    private let order: DeliveryOrderResponse

    init(apiService: ApiService, order: DeliveryOrderResponse) {
        self.order = order
        self.apiService = apiService
    }

    func transform(input: Input) -> Output {
        let result = input.ratingSelected
            .withLatestFrom(input.ratingValue)
            .flatMap { [unowned self] ratingValue -> Observable<ResponseStatus> in
                return self.apiService.makeRequest(
                    to: CreateOrderRatings.createOrderRatings(
                        comment: "",
                        orderId: self.order.id ?? 0,
                        type: 1,
                        value: ratingValue))
                    .result(ResponseStatus.self)
            }.asLoadingSequence().share()
        return .init(result: result)
    }
}
