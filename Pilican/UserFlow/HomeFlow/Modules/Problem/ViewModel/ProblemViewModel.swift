//
//  ProblemViewModel.swift
//  Pilican
//
//  Created by kairzhan on 3/4/21.
//

import RxSwift

final class ProblemViewModel: ViewModel {

    struct Input {
        let sendTapped: Observable<Void>
        let claimIds: Observable<String>
        let description: Observable<String?>
    }

    struct Output {
        let claims: Observable<LoadingSequence<ResponseStatus>>
    }

    private let retailId: Int
    private let apiService: ApiService

    init(apiService: ApiService, retailId: Int) {
        self.retailId = retailId
        self.apiService = apiService
    }

    func transform(input: Input) -> Output {
        let claims = input.sendTapped
            .withLatestFrom(Observable.combineLatest(input.claimIds, input.description))
            .flatMap { [unowned self] claimIds, description in
                apiService.makeRequest(to: ProblemTarget.sendClaims(
                                        claimIds: claimIds,
                                        retailId: self.retailId,
                                        description: description ?? ""))
                    .result(ResponseStatus.self)
            }.asLoadingSequence()
        return .init(claims: claims)
    }
}
