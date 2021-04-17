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
            .do(onNext: { [unowned self] products in
                self.rootView.setupAmount(products: products)
            })
            .bind(to: rootView.tableView.rx.items(BasketItemViewCell.self)) { _, model, cell  in
                cell.setup(product: model)
                cell.addProduct = { product in
                    self.changeDishList(action: .addToDish(product!))
                }
                cell.removeProduct = { product in
                    self.changeDishList(action: .removeFromDish(product))
                }
                cell.contentView.isUserInteractionEnabled = false
            }.disposed(by: disposeBag)
    }
    
    func changeDishList(action: DishListAction) {
       _ = viewModel.dishList.changeDishList(dishAction: action)
    }
    
    private func bindView() {
        rootView.setupUserInfo(storage: viewModel.userInfo)
        rootView.tableView.rowHeight = 100
        rootView.tableView.estimatedRowHeight = 100
    }
}
