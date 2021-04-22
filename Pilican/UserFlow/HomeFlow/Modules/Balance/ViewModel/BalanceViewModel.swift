//
//  BalanceViewModel.swift
//  Pilican
//
//  Created by kairzhan on 4/20/21.
//

import RxSwift

final class BalanceViewModel: ViewModel {
    
    struct Input {
        let replenishTapped: Observable<Void>
        let amount: Observable<String?>
    }
    
    struct Output {
        let result: Observable<LoadingSequence<BalanceResponse>>
    }
    
    private let userSessionStorage: UserSessionStorage
    private let apiService: ApiService
    
    init(apiService: ApiService, userSessionStorage: UserSessionStorage) {
        self.apiService = apiService
        self.userSessionStorage = userSessionStorage
    }
    
    func transform(input: Input) -> Output {
        let result = input.replenishTapped
            .withLatestFrom(input.amount)
            .flatMap { [unowned self] amount -> Observable<BalanceResponse> in
                let createdAt = String(NSDate().timeIntervalSince1970).split(separator: ".")[0]
                let token = userSessionStorage.accessToken
                let newAccessToken = ((token! as NSString).substring(with: NSMakeRange(11, 21)) as NSString).substring(with:  NSMakeRange(0, 10))
                let sig = ((newAccessToken + String(amount ?? "") + String(createdAt)).toBase64()).md5()
                return apiService.makeRequest(
                    to: BalanceTarget.replenishBalance(
                    sig: String(sig),
                        amount: Float(Double(amount ?? "") ?? 0),
                    createdAt: String(createdAt)))
                    .result(BalanceResponse.self)
            }.asLoadingSequence()
        return .init(result: result)
    }
}
