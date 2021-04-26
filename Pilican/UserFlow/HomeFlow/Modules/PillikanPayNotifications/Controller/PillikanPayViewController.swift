import UIKit
import RxSwift

final class PillikanPayViewController: ViewController, ViewHolder, PillikanPayModule {
    var closeButton: CloseButton?
    
    typealias RootViewType = PillikanPayView
    
    private let viewModel: PillikanPayViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: PillikanPayViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func loadView() {
        view = PillikanPayView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        
        let output = viewModel.transform(input: .init(loadNotifications: .just(())))
        
        let notificationList = output.notificationList.publish()
        
        let adapter = viewModel.adapter
        adapter.connect(to: rootView.tableView)
        adapter.start()
        
        notificationList.loading
            .bind(to: ProgressView.instance.rx.loading)
            .disposed(by: disposeBag)
        
        notificationList.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)
        
        notificationList.element
            .bind(to: rootView.tableView.rx.items(PillikanNotificationTableViewCell.self)) { _, model, cell in
                cell.setupNotifications(notification: model)
            }.disposed(by: disposeBag)
        
        notificationList.connect()
            .disposed(by: disposeBag)
    }
    
    override func customBackButtonDidTap() {
        closeButton?()
    }
}
