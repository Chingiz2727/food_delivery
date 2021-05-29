import RxSwift
import UIKit

class DeliveryRetailProductsViewController: UIViewController, DeliveryRetailProductsModule, ViewHolder {
    var alcohol: Alcohol?
    
    var favoriteButtonTapped: FavoriteButtonTapped?

    typealias RootViewType = DeliveryRetailProductsView
    
    var onMakeOrdedDidTap: Callback?

    private let viewModel: DeliveryRetailProductViewModel
    private let disposeBag = DisposeBag()
    private let sourceDelegate: DeliveryRetailTableViewDataSourceDelegate
    private var isFavorite = false
    private var alertIsShown = false
    private let favouriteManager: FavouritesManager
    private let workCalendar: WorkCalendar
    init(viewModel: DeliveryRetailProductViewModel, favouriteManager: FavouritesManager, workCalendar: WorkCalendar) {
        self.viewModel = viewModel
        self.workCalendar = workCalendar
        self.favouriteManager = favouriteManager
        self.sourceDelegate = DeliveryRetailTableViewDataSourceDelegate(dishList: viewModel.dishList)
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func loadView() {
        view = DeliveryRetailProductsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        bindView()
        alertIsShown = false
        rootView.tableView.rowHeight = UITableView.automaticDimension
        rootView.tableView.estimatedRowHeight = 140
        navigationItem.title = viewModel.retailInfo.name
        viewModel.dishList.products = []
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let tabbar = tabBarController as? HomeTabBarViewController {
            tabbar.tabBar.isHidden = true
            HomeTabBarViewController.qrScanButton.isHidden = true
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let tabbar = tabBarController as? HomeTabBarViewController {
            tabbar.tabBar.isHidden = false
            HomeTabBarViewController.qrScanButton.isHidden = false
        }
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: .init(viewDidLoad: Observable.merge(.just(()), rootView.rx.retryAction)))

        rootView.stickyHeaderView.favouriteButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.favouriteManager.saveToFavourite(id: self.viewModel.dishList.retail?.id ?? 0) { [unowned self] in
                    let isfav = self.favouriteManager.getIsFavourite(id: self.viewModel.dishList.retail?.id ?? 0)
                    self.rootView.stickyHeaderView.setFavouriteButton(favourite: isfav)
                }
            })
            .disposed(by: disposeBag)

        let isfav = self.favouriteManager.getIsFavourite(id: self.viewModel.dishList.retail?.id ?? 0)
        self.rootView.stickyHeaderView.setFavouriteButton(favourite: isfav)

        let productList = output.productsList.publish()
        productList.loading
            .bind(to: ProgressView.instance.rx.loading)
            .disposed(by: disposeBag)

        productList.element
            .subscribe(onNext: { [unowned self] retail in
                self.rootView.setRetail(retail: self.viewModel.dishList.retail!, calendar: workCalendar, rating: retail.retail.rating)
                let productCategory = self.viewModel.dishList.checkForContainProductOnDish(listCategory: retail.retail.deliveryCategories)
                let categoriesTitle = productCategory.map { $0.name }
                self.rootView.setTitles(titles: categoriesTitle)
                self.sourceDelegate.productCategory = productCategory
                self.rootView.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        productList.errors
            .bind(to: rootView.rx.error)
            .disposed(by: disposeBag)

        productList.connect()
            .disposed(by: disposeBag)

        viewModel.dishList.wishDishList
            .subscribe(onNext: { [unowned self] product in
                product.forEach { (product) in
                    if product.age_access == 1 && self.alertIsShown == false {
                        self.alcohol?()
                        self.alertIsShown = true
                    }
                }
                self.rootView.setProductToPay(product: product)
            })
            .disposed(by: disposeBag)

        rootView.setProductToPay(product: viewModel.dishList.products)
    }

    private func bindView() {
        rootView.tableView.rx.setDelegate(sourceDelegate)
            .disposed(by: disposeBag)

        rootView.tableView.rx.setDataSource(sourceDelegate)
            .disposed(by: disposeBag)

        rootView.tableView.rx.contentOffset
            .subscribe(onNext: { [unowned self] offset in
                if self.rootView.tableView.numberOfSections > 2 {
                    self.rootView.setupHeader(point: offset.y)
                }
            })
            .disposed(by: disposeBag)

        rootView.tableView.rx.willDisplayCell.asObservable()
            .subscribe(onNext: { [unowned self] _, indexPath in
//                self.rootView.setupHeader(point: indexPath.section)
                if self.rootView.tableView.numberOfSections > 2 {
                    self.rootView.scrollSegmentToSection(section: indexPath.section)
                }
            })
            .disposed(by: disposeBag)

        rootView.segmentControl.rx.selectedIndex
            .subscribe(onNext: { [unowned self] section in
                if self.rootView.tableView.numberOfSections > 2 {
                    self.rootView.tableView.scrollToRow(at: .init(row: 0, section: section), at: .top, animated: true)
                }
            })
            .disposed(by: disposeBag)
        rootView.calculateView.control.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                self.onMakeOrdedDidTap?()
            })
            .disposed(by: disposeBag)

        rootView.stickyHeaderView.favouriteButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                rootView.stickyHeaderView.favouriteButton.setImage(isFavorite ? Images.fillStar.image : Images.emptyStar.image, for: .normal)
                isFavorite = !isFavorite
            }).disposed(by: disposeBag)
    }
}
