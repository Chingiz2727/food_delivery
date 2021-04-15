import RxSwift
import UIKit

class MakeOrderViewController: ViewController, MakeOrderModule, ViewHolder {

    typealias RootViewType = MakeOrderView
    private let viewModel: MakeOrderViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: MakeOrderViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func loadView() {
        view = MakeOrderView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        bindView()
    }
    
    private func bindViewModel() {
        viewModel.dishList.wishDishList
            .bind(to: rootView.tableView.rx.items(BasketItemViewCell.self)) { _, model, cell  in
                cell.setup(product: model)
                cell.addProduct = { [unowned self] in
                    _ = self.viewModel.dishList.changeDishList(dishAction: .addToDish(model))
                }
                cell.removeProduct = { [unowned self] in
                    _ = self.viewModel.dishList.changeDishList(dishAction: .removeFromDish(model))
                }
            }.disposed(by: disposeBag)
    }
    
    private func bindView() {
        rootView.setupUserInfo(storage: viewModel.userInfo)
        rootView.tableView.rowHeight = 100
        rootView.tableView.estimatedRowHeight = 100
    }
}
