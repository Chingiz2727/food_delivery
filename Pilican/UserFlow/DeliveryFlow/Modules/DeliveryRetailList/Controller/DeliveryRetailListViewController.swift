import RxSwift
import UIKit

final class DeliveryRetailListViewController: UIViewController, DeliveryRetailListModule, ViewHolder {
    typealias RootViewType = DeliveryRetailListView

    var onRetailDidSelect: OnRetailDidSelect?

    private let viewModel: DeliveryRetailListViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: DeliveryRetailListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }

    override func loadView() {
        view = DeliveryRetailListView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: .init(loadRetailList: .just(())))

        let retailList = output.retailList.publish()

        let adapter = viewModel.adapter
        adapter.connect(to: rootView.tableView)
        adapter.start()
        
        retailList.loading
            .bind(to: ProgressView.instance.rx.loading)
            .disposed(by: disposeBag)

        retailList.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)

        retailList.element
            .bind(to: rootView.tableView.rx.items(DeliveryRetailListTableViewCell.self)) { _, model, cell in
                cell.setRetail(retail: model)
            }
            .disposed(by: disposeBag)

        rootView.tableView.rx.itemSelected
            .withLatestFrom(retailList.element) { $1[$0.row] }
            .bind { [unowned self] retail in
                self.onRetailDidSelect?(retail)
            }
            .disposed(by: disposeBag)

        retailList.connect()
            .disposed(by: disposeBag)
    }
}
