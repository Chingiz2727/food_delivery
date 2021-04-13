import RxSwift
import UIKit

final class PillikanInfoViewModel: ViewModel {
    lazy var adapter = PaginationAdapter(manager: manager)
    
    private lazy var manager = PaginationManager<NotificationResponse> { [unowned self]  page, _, _ in
        return self.apiService.makeRequest(
            to: NotificationTarget.notificationMessage(pageNumber: page)
        ).result()
    }
    
    private let apiService: ApiService
    private let disposeBag = DisposeBag()
    
    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    struct Input {
        let loadNotifications: Observable<Void>
    }
    
    struct Output {
        let notificationList: Observable<LoadingSequence<[NotificationInfo]>>
    }
    
    func transform(input: Input) -> Output {
        input.loadNotifications
            .subscribe(onNext: { [unowned self] in
                self.manager.resetData()
            }).disposed(by: disposeBag)
        
        return .init(notificationList: manager.contentUpdate.asLoadingSequence())
    }
    
    
}
