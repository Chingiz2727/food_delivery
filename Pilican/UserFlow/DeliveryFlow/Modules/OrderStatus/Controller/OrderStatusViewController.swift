import RxSwift
import UIKit

class OrderStatusViewController: UIViewController, ViewHolder, OrderStatusModule {
    typealias RootViewType = OrderStatusView
    
    private let viewModel: OrderStatusViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: OrderStatusViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func loadView() {
        view = OrderStatusView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: .init(loadView: .just(())))
        let status = output.status.publish()
        
        status.loading
            .bind(to: ProgressView.instance.rx.loading)
            .disposed(by: disposeBag)
        
        status.element
            .subscribe(onNext: { [unowned self] status in
                self.rootView.setData(response: status.order)
            })
            .disposed(by: disposeBag)
        
        status.connect()
            .disposed(by: disposeBag)
    }
}
