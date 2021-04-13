import UIKit
import RxSwift

class OrderTypeViewController: ViewController, ViewHolder, OrderTypeModule {
    typealias RootViewType = OrderTypeView
    private let orderCases = OrderType.allCases
    private let disposeBag = DisposeBag()
    private let dishList: DishList
    
    init(dishList: DishList) {
        self.dishList = dishList
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func loadView() {
        view = OrderTypeView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        dishList.wishDishList
            .subscribe(onNext: { [unowned self] product in
                self.rootView.setup(product: product)
            })
            .disposed(by: disposeBag)
        
        Observable.just(orderCases)
            .bind(to: rootView.tableView.rx.items(OrderTypeTableViewCell.self)) { _, model, cell in
                cell.setup(orderType: model)
            }.disposed(by: disposeBag)
    }
}
