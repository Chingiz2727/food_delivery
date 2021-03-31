import RxSwift
import UIKit

class DeliveryRetailProductsViewController: UIViewController, DeliveryRetailProductsModule, ViewHolder {
    typealias RootViewType = DeliveryRetailProductsView
    
    private let viewModel: DeliveryRetailProductViewModel
    private let disposeBag = DisposeBag()
    private let dataSource = DeliveryRetailProductDataSource()
    
    init(viewModel: DeliveryRetailProductViewModel) {
        self.viewModel = viewModel
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
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: .init(viewDidLoad: .just(())))
        let productList = output.productsList.publish()
        productList.loading
            .bind(to: ProgressView.instance.rx.loading)
            .disposed(by: disposeBag)
        
        productList.element
            .map { $0.retail.deliveryCategories }
            .do(onNext: { [unowned self] products in
                let categories = products.map { $0.name }
                self.rootView.setTitles(titles: categories)
            })
            .bind(to: rootView.tableView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        productList.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)

        productList.connect()
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
