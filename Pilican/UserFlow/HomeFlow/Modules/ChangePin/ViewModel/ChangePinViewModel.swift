//
//  ChangePinViewModel.swift
//  Pilican
//
//  Created by kairzhan on 4/5/21.
//

import RxSwift

final class ChangePinViewModel: ViewModel {
    struct Input {
        let saveTapped: Observable<Void>
        let password: Observable<String?>
        let newPin: Observable<String?>
        let acceptPin: Observable<String?>
    }

    struct Output {
        let changedPin: Observable<LoadingSequence<PinCodeResponse>>
    }
    
    private let apiService: ApiService
    
    init(apiservice: ApiService) {
        self.apiService = apiservice
    }

    func transform(input: Input) -> Output {
        let changePin = input.saveTapped
            .withLatestFrom(Observable.combineLatest(input.newPin, input.acceptPin, input.password))
            .flatMap { [unowned self] newpin, acceptPin, password in
                return self.apiService.makeRequest(to: AuthTarget.changePin(password: password ?? "", newPin: newpin ?? "", acceptPin: acceptPin ?? ""))
                    .result(PinCodeResponse.self)
                    .asLoadingSequence()
            }.share()
        return .init(changedPin: changePin)
    }
}
