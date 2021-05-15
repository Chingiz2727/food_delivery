import UIKit
import RxSwift

final class NotificationListController: ViewController, ViewHolder, NotificationListModule {
    var closeButton: CloseButton?
    
    typealias RootViewType = NotificationListView
    
    var notificationsListDidSelect: NotificationsListDidSelect?
    private let disposeBag = DisposeBag()
    
    override func loadView() {
        view = NotificationListView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.post(name: NSNotification.Name.init(NotificationsString.removeBadge.rawValue), object: nil, userInfo: nil)
        UIApplication.shared.applicationIconBadgeNumber = 0
        bindView()
        title = "Сообщения"
    }
    
    func bindView() {
        Observable.just(NotificationsList.allCases)
            .bind(to: rootView.tableView.rx.items(NotificationListTableViewCell.self)) {_, model, cell in
                cell.setupTexts(notification: model)
            }
            .disposed(by: disposeBag)
        
        rootView.tableView.rx.itemSelected
            .withLatestFrom(Observable.just(NotificationsList.allCases)) { $1[$0.row] }
            .bind { [unowned self] notificationsItem in
                self.notificationsListDidSelect?(notificationsItem)
            }.disposed(by: disposeBag)
    }
    
    override func customBackButtonDidTap() {
        closeButton?()
    }
    
}
