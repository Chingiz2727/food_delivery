import RxSwift
import UIKit

final class DeliveryRetailListViewController: UIViewController, DeliveryRetailListModule, ViewHolder {
    var deliveryMenuDidSelect: DeliveryMenuDidSelect?
    
    typealias RootViewType = DeliveryRetailListView

    var onRetailDidSelect: OnRetailDidSelect?
    var onSelectToStatus: OnSelectStatus?
    private let viewModel: DeliveryRetailListViewModel
    private let disposeBag = DisposeBag()
    private let dishList: DishList
    
    init(viewModel: DeliveryRetailListViewModel, dishList: DishList) {
        self.viewModel = viewModel
        self.dishList = dishList
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: Images.deliveryMenu.image?.withRenderingMode(.alwaysOriginal),
            style: .done,
            target: self,
            action: #selector(showMenu))
    }

    @objc private func showMenu() {
        deliveryMenuDidSelect?()
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
            .bind(to: rootView.tableView.rx.items(DeliveryRetailListTableViewCell.self)) { type, model, cell in
                cell.setRetail(retail: model)
            }
            .disposed(by: disposeBag)

        rootView.tableView.rx.itemSelected
            .withLatestFrom(retailList.element) { $1[$0.row] }
            .bind { [unowned self] retail in
                if retail.id != dishList.retail?.id && !dishList.products.isEmpty {
                    showBasketAlert {
                        self.dishList.products = []
                        self.dishList.wishDishList.onNext([])
                        self.onRetailDidSelect?(retail)
                    }
                }
                if retail.isWork == 1 {
                    self.onRetailDidSelect?(retail)
                }
            }
            .disposed(by: disposeBag)

        retailList.connect()
            .disposed(by: disposeBag)
    }
}
