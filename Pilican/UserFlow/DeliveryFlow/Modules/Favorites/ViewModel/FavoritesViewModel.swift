//
//  FavoritesViewModel.swift
//  Pilican
//
//  Created by kairzhan on 4/16/21.
//

import RxSwift

class FavoritesViewModel: ViewModel {
    lazy var adapter = PaginationAdapter(manager: manager)

    private lazy var manager = PaginationManager<DeliveryRetailList> { [unowned self] page, pageSize, _ in
        return self.apiService.makeRequest(
            to: FavoritesTarget.getFavoriteRetails(type: 1)
        )
        .result()
    }

    private let apiService: ApiService
    private let disposeBag = DisposeBag()

    init(apiService: ApiService) {
        self.apiService = apiService
    }

    struct Input {
        let loadFavorites: Observable<Void>
    }

    struct Output {
        let retailList: Observable<LoadingSequence<[DeliveryRetail]>>
    }

    func transform(input: Input) -> Output {
        input.loadFavorites
            .subscribe(onNext: { [unowned self] in
                self.manager.resetData()
            })
            .disposed(by: disposeBag)

        return .init(retailList: manager.contentUpdate.asLoadingSequence())
    }
}
