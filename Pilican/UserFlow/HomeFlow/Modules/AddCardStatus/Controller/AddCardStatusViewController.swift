import RxSwift
import UIKit

class AddCardStatusViewController: UIViewController, AddCardStatusModule, ViewHolder {
    
    typealias RootViewType = AddCardStatusView
    
    var onCloseDidTap: Callback?
    
    var onReturnDidTap: Callback?
    
    private let status: Status
    private let diposeBag = DisposeBag()
    
    init(status: Status) {
        self.status = status
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func loadView() {
        view = AddCardStatusView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.setupStatus(status: status)
        rootView.exitButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                switch self.status {
                case .failure:
                    self.onReturnDidTap?()
                case .succes:
                    self.onCloseDidTap?()
                }
            })
            .disposed(by: diposeBag)
    }
    
}
