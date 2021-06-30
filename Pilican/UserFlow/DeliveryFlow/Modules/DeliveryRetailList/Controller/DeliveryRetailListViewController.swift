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
    private let searchText: PublishSubject<String> = .init()
    private var sliderId = 0
    private let analyticManager = assembler.resolver.resolve(PillicanAnalyticManager.self)!
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
        navigationItem.title = "Доставка"
        analyticManager.log(.deliveryMain)
    }

    @objc private func showMenu() {
        deliveryMenuDidSelect?()
    }

    private func bindViewModel() {
        rootView.searchTableView.registerClassForCell(DeliveryRetailListTableViewCell.self)
        let output = viewModel.transform(input: .init(
                                            loadRetailList: Observable.merge(.just(()), rootView.rx.retryAction),
                                            loadSlider: Observable.merge(.just(()), rootView.rx.retryAction),
                                            text: rootView.searchBar.rx.text.unwrap()))
        
        let searchRetails = output.searchRetails.publish()

        let slider = output.sliders.publish()

//        slider.loading
//            .bind(to: ProgressView.instance.rx.loading)
//            .disposed(by: disposeBag)
////
////        slider.errors
////            .bind(to: rootView.rx.error)
////            .disposed(by: disposeBag)
        
        slider.subscribe(onNext: { [unowned self] sliders in
            guard let sliderList = sliders.result?.element else { return }
            self.rootView.header.setupSlider(sliders: sliderList.sliders)
        }).disposed(by: disposeBag)

        slider.connect()
            .disposed(by: disposeBag)

        let retailList = output.retailList.publish()

        let adapter = viewModel.adapter
        adapter.connect(to: rootView.tableView)
        adapter.start()

        retailList.loading
            .bind(to: ProgressView.instance.rx.loading)
            .disposed(by: disposeBag)

        retailList.errors
            .bind(to: rootView.rx.error)
            .disposed(by: disposeBag)

        retailList.element
            .bind(to: rootView.tableView.rx.items(DeliveryRetailListTableViewCell.self)) { _, model, cell in
                cell.setRetail(retail: model)
            }
            .disposed(by: disposeBag)

        rootView.tableView.rx.itemSelected
            .withLatestFrom(retailList.element) { $1[$0.row] }
            .bind { [unowned self] retail in
                if retail.isWork == 1 {
                    if retail.id != dishList.retail?.id && !dishList.products.isEmpty {
                        showBasketAlert {
                            self.dishList.products = []
                            self.dishList.wishDishList.onNext([])
                            self.onRetailDidSelect?(retail)
                        }
                    } else {
                        self.onRetailDidSelect?(retail)
                    }
                }
            }
            .disposed(by: disposeBag)

        retailList.connect()
            .disposed(by: disposeBag)

        searchRetails.element
            .map { $0.retails.content }
            .bind(to: rootView.searchTableView.rx.items(DeliveryRetailListTableViewCell.self)) { _, model, cell in
                cell.setRetail(retail: model)
            }.disposed(by: disposeBag)

        rootView.searchBar.rx.text.unwrap()
            .subscribe(onNext: { [unowned self] text in
                self.rootView.searchTableView.isHidden = text.isEmpty
                self.rootView.searchViewBack.isHidden = text.isEmpty
            }).disposed(by: disposeBag)
        
        rootView.searchTableView.rx.itemSelected
            .withLatestFrom(searchRetails.element) { $1.retails.content[$0.row] }
            .bind { [unowned self] retail in
                self.analyticManager.log(.deliverysearch)
                if retail.isWork == 1 {
                    if retail.id != dishList.retail?.id && !dishList.products.isEmpty {
                        showBasketAlert {
                            self.dishList.products = []
                            self.dishList.wishDishList.onNext([])
                            self.onRetailDidSelect?(retail)
                        }
                    } else {
                        self.onRetailDidSelect?(retail)
                    }
                }
            }.disposed(by: disposeBag)

        searchRetails.loading
            .bind(to: ProgressView.instance.rx.loading)
            .disposed(by: disposeBag)

        searchRetails.errors
            .bind(to: rootView.rx.error)
            .disposed(by: disposeBag)

        searchRetails.connect()
            .disposed(by: disposeBag)
        rootView.header.retailSliderId
            .subscribe(onNext: { [unowned self] retail in
                guard let retail = retail else { return }
                self.analyticManager.log(.deliverysearch)
                if retail.isWork == 1 {
                    if retail.id != dishList.retail?.id && !dishList.products.isEmpty {
                        showBasketAlert {
                            self.dishList.products = []
                            self.dishList.wishDishList.onNext([])
                            self.onRetailDidSelect?(retail)
                        }
                    } else {
                        self.onRetailDidSelect?(retail)
                    }
                }
            })
//        rootView.header.retailSliderId
//            .withLatestFrom(retailList.element) { id, retails in
//                    return retails.filter { $0.id != 0 }
//                }.subscribe(onNext: { [unowned self] retails in
//                    if let retail = retails.first {
//                        if retail.isWork == 1 {
//                            if retail.id != dishList.retail?.id && !dishList.products.isEmpty {
//                                showBasketAlert {
//                                    self.dishList.products = []
//                                    self.dishList.wishDishList.onNext([])
//                                    // swiftlint:disable line_length
//                                    self.onRetailDidSelect?(DeliveryRetail(id: retail.id, cashBack: 0, isWork: 0, longitude: 0, latitude: 0, dlvCashBack: 0, pillikanDelivery: 0, logo: "", address: "", workDays: [], payIsWork: 0, name: "", status: 0, rating: 0))
//                                }
//                            } else {
//                                // swiftlint:disable line_length
//                                self.onRetailDidSelect?(DeliveryRetail(id: retail.id, cashBack: 0, isWork: 0, longitude: 0, latitude: 0, dlvCashBack: 0, pillikanDelivery: 0, logo: "", address: "", workDays: [], payIsWork: 0, name: "", status: 0, rating: 0))
//                            }
//                        }
//                    }
//                })
//                .disposed(by: disposeBag)
    }
}
