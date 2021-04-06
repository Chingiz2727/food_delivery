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
        let changePassword = input.saveTapped
            .withLatestFrom(Observable.combineLatest(input.acceptPassword, input.newPassword))
            .flatMap { [unowned self] newPassword, acceptPassword in
                return self.apiService.makeRequest(to:
                    AuthTarget.changePassword(newPassword: newPassword ?? "", acceptPassword: acceptPassword ?? ""))
                    .result(ResponseStatus.self)
                    .asLoadingSequence()
            }.share()
        return .init(changedPassword: changePassword)
    }
}
