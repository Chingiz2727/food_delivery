import RxSwift
import UIKit

class DeliveryRetailProductsViewController: UIViewController, DeliveryRetailProductsModule, ViewHolder {
    typealias RootViewType = DeliveryRetailProductsView
    
    private let viewModel: DeliveryRetailProductViewModel
    private let disposeBag = DisposeBag()
    private let sourceDelegate: DeliveryRetailTableViewDataSourceDelegate

    init(viewModel: DeliveryRetailProductViewModel) {
        self.viewModel = viewModel
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
        rootView.setRetail(retail: viewModel.retailInfo)
        bindViewModel()
        bindView()
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: .init(viewDidLoad: .just(())))
        let productList = output.productsList.publish()
        productList.loading
            .bind(to: ProgressView.instance.rx.loading)
            .disposed(by: disposeBag)
        
        productList.element
            .map { $0.retail.deliveryCategories }
            .subscribe(onNext: { [unowned self] products in
                let productCategory = self.viewModel.dishList.checkForContainProductOnDish(listCategory: products)
                let categoriesTitle = productCategory.map { $0.name }
                self.rootView.setTitles(titles: categoriesTitle)
                self.sourceDelegate.productCategory = productCategory
                self.rootView.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        productList.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)

        productList.connect()
            .disposed(by: disposeBag)
        
        viewModel.dishList.dishList
            .subscribe(onNext: { [unowned self] product in
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
                self.rootView.setupHeader(point: offset.y)
            })
            .disposed(by: disposeBag)

        rootView.tableView.rx.willDisplayCell.asObservable()
            .subscribe(onNext: { [unowned self] _, indexPath in
                self.rootView.scrollSegmentToSection(section: indexPath.section)
            })
            .disposed(by: disposeBag)
        
        rootView.segmentControl.rx.selectedIndex
            .subscribe(onNext: { [unowned self] section in
                if self.rootView.tableView.numberOfSections != 0 {
                    self.rootView.tableView.scrollToRow(at: .init(row: 0, section: section), at: .top, animated: true)
                }
            })
            .disposed(by: disposeBag)
    }
}
