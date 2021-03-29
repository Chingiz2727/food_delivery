//
//  CameraViewModel.swift
//  Pilican
//
//  Created by kairzhan on 3/25/21.
//

import RxSwift

final class CameraViewModel: ViewModel {
    
    struct Input {
        let loadInfo: Observable<Void>
        let createdAt: Observable<String>
        let sig: Observable<String>
        let retailId: Observable<Int>
    }
    
    struct Output {
        let scanRetailResponse: Observable<LoadingSequence<ScanRetailResponse>>
    }
    
    private let apiService: ApiService

    init(apiService: ApiService) {
        self.apiService = apiService
    }

    func transform(input: Input) -> Output {
        let scanRetailResponse = input.loadInfo
            .withLatestFrom(Observable.combineLatest(input.createdAt, input.sig, input.retailId))
            .flatMap { [unowned self] createdAt, sig, retailId in
                apiService.makeRequest(to: CameraTarget.retailScan(
                                        retailId: retailId,
                                        createdAt: createdAt,
                                        sig: sig))
                    .result(ScanRetailResponse.self)
            }.asLoadingSequence()
        return .init(scanRetailResponse: scanRetailResponse)
    }
}
