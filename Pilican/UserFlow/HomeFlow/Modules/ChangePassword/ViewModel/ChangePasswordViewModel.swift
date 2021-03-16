//
//  ChangePasswordViewModel.swift
//  Pilican
//
//  Created by kairzhan on 3/16/21.
//

import RxSwift

final class ChangePasswordViewModel: ViewModel {
    
    struct Input {
        let saveTapped: Observable<Void>
        let newPassword: Observable<String?>
        let acceptPassword: Observable<String?>
    }

    struct Output {
        let changedPassword: Observable<LoadingSequence<ResponseStatus>>
    }

    private let apiService: ApiService

    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    func transform(input: Input) -> Output {
        let changedPassword = input.saveTapped
            .withLatestFrom(
                Observable.combineLatest(
                    input.newPassword,
                    input.acceptPassword
                ).flatMap { [unowned self] newPassword, acceptPassword in
                    return apiService.makeRequest(
                        to: AuthTarget.changePassword(
                            newPassword: newPassword ?? "new",
                            acceptPassword: acceptPassword ?? "accept"))
                        .result(ResponseStatus.self)
                }.asLoadingSequence()
            )
        return .init(changedPassword: changedPassword)
    }
}
