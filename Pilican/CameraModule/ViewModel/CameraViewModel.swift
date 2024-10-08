//
//  CameraViewModel.swift
//  Pilican
//
//  Created by kairzhan on 3/25/21.
//

import RxSwift

final class CameraViewModel: ViewModel {
    
    lazy var adapter = PaginationAdapter(manager: manager)
    
    private lazy var manager = PaginationManager<RetailList> { [unowned self] page, pageSize, _ in
        return self.apiService.makeRequest(
            to: HomeApiTarget.retailList(pageNumber: page, size: pageSize)
        )
        .result()
    }
    
    private let apiService: ApiService
    private let disposeBag = DisposeBag()
    private var categoryId: Int = 1
    var retail: PublishSubject<[Retail]> = .init()
    
    init(apiService: ApiService) {
        self.apiService = apiService
        self.categoryId = 1
    }
    
    struct Input {
        let loadInfo: Observable<Void>
        let createdAt: Observable<String>
        let sig: Observable<String>
        let retailId: Observable<Int>
        let loadRetails: Observable<Void>
        let retailIdentifier: Observable<String?>
        let searchButtonTap: Observable<Void>
    }
    
    struct Output {
        let scanRetailResponse: Observable<LoadingSequence<ScanRetailResponse>>
        let retailList: Observable<LoadingSequence<[Retail]>>
    }

    func transform(input: Input) -> Output {
        let scanRetailResponse = input.loadInfo
            .withLatestFrom(Observable.combineLatest(input.createdAt, input.sig, input.retailId))
            .flatMap { [unowned self] createdAt, sig, retailId in
                self.apiService.makeRequest(to: CameraTarget.retailScan(
                                        retailId: retailId,
                                        createdAt: createdAt,
                                        sig: sig))
                    .result(ScanRetailResponse.self)
                    .asLoadingSequence()
            }.share()
        
        input.loadRetails
            .subscribe(onNext: { [unowned self] in
                self.manager.resetData()
            })
            .disposed(by: disposeBag)
        
        let retailIden = input.searchButtonTap
            .withLatestFrom(input.retailIdentifier)
            .flatMap { [unowned self] retailIdentifier in
                self.apiService.makeRequest(to: HomeApiTarget.findRetailById(id: Int(retailIdentifier ?? "") ?? 0))
                    .result(FindByIdResponse.self)
                    .asLoadingSequence()
            }.share()
            .element
            .subscribe(onNext: { [unowned self] id in
                self.retail.onNext([id.retail])
            })
            .disposed(by: disposeBag)
        
        manager.contentUpdate.subscribe(onNext: { [unowned self] retail in
            self.retail.onNext(retail)
        }).disposed(by: disposeBag)
        
        return .init(scanRetailResponse: scanRetailResponse, retailList: retail.asLoadingSequence())
    }
}
