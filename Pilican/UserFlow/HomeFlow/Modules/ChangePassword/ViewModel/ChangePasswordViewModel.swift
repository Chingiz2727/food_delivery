//
//  ChangePasswordViewModel.swift
//  Pilican
//
//  Created by kairzhan on 3/16/21.
//
import Moya
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

    private let statusSubject = PublishSubject<LoadingSequence<ResponseStatus>>()
    private let apiService: ApiService
    private let disposeBag = DisposeBag()
    init(apiService: ApiService) {
        self.apiService = apiService
    }

    func transform(input: Input) -> Output {
        let set = input.saveTapped
            .withLatestFrom(Observable.combineLatest(input.acceptPassword, input.newPassword))
            .flatMap { [unowned self] newPassword, acceptPassword in
                return self.apiService.makeRequest(to:
                    AuthTarget.changePassword(newPassword: newPassword ?? "", acceptPassword: acceptPassword ?? ""))
                    .result(ResponseStatus.self)
                    .asLoadingSequence()
            }.share()
        
        return .init(changedPassword: set)
    }
    
    private func changePassword(password: String, password1: String) {
        MoyaApiService.shared.changePassword(password: password, password1: password1) { response, error in
            if let response = response {

                let items = LoadingSequence.init(result: .success(response))
                self.statusSubject.onNext(items)
            } else {
                self.statusSubject.onNext(LoadingSequence.init(result: .error(error!)))
            }
        }
    }
}
