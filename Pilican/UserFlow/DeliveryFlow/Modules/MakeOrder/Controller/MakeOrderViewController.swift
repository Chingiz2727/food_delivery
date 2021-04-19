import RxSwift
import YandexMapsMobile
import UIKit

class MakeOrderViewController: ViewController, MakeOrderModule, ViewHolder {

    typealias RootViewType = MakeOrderView
    var onMapShowDidSelect: Callback?
    private let viewModel: MakeOrderViewModel
    private let disposeBag = DisposeBag()
    private let mapManager: MapManager<YandexMapViewModel>
    private var searchManager: YMKSearchManager?
    private var searchSession: YMKSearchSession?

    init(viewModel: MakeOrderViewModel, mapManager: MapManager<YandexMapViewModel>) {
        self.viewModel = viewModel
        self.mapManager = mapManager
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
        searchManager = YMKSearch.sharedInstance().createSearchManager(with: .combined)
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
        
        rootView.addressView.control.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                self.onMapShowDidSelect?()
            }).disposed(by: disposeBag)
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

