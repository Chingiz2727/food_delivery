import RxSwift
import UIKit

class ItemSearchViewController: SearchViewController, ItemSearchModule {
    var onDeliveryRetailCompanyDidSelect: OnDeliveryCompanyDidSelect?

    private let viewModel: ItemSearchViewMoodel
    private let disposeBag = DisposeBag()
    private let searchText: PublishSubject<String> = .init()
    private let dishList: DishList
    private let analytics = assembler.resolver.resolve(PillicanAnalyticManager.self)!

    init(viewModel: ItemSearchViewMoodel, dishList: DishList) {
        self.viewModel = viewModel
        self.dishList = dishList
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = "Поиск"
        rootView.tableView.registerClassForCell(DeliveryRetailListTableViewCell.self)
        bindViewModel()
        analytics.log(.deliverysearch)
    }

    private func bindViewModel() {
        let output = viewModel.transform(input: .init(text: searchText, loadTags: .just(())))
        let retailList = output.retailList.publish()

        retailList.element
            .map { $0.retails.content }
            .bind(to: rootView.tableView.rx.items(DeliveryRetailListTableViewCell.self)) { _, model, cell in
                cell.setRetail(retail: model)
            }
            .disposed(by: disposeBag)

        retailList.loading
            .bind(to: ProgressView.instance.rx.loading)
            .disposed(by: disposeBag)

        rootView.tableView.rx.itemSelected
            .withLatestFrom(retailList.element) { $1.retails.content[$0.row] }
            .bind { [unowned self] retail in
                if retail.isWork == 1 {
                    if retail.id != dishList.retail?.id && !dishList.products.isEmpty {
                        showBasketAlert {
                            self.dishList.products = []
                            self.dishList.wishDishList.onNext([])
                            self.onDeliveryRetailCompanyDidSelect?(retail)
                        }
                    } else {
                        self.onDeliveryRetailCompanyDidSelect?(retail)
                    }
                }
            }.disposed(by: disposeBag)
        
        retailList.connect()
            .disposed(by: disposeBag)

        let tags = output.tags.publish()

        tags.loading
            .bind(to: ProgressView.instance.rx.loading)
            .disposed(by: disposeBag)

        tags.element
            .subscribe(onNext: { [unowned self] tag in
                self.rootView.searchTagsView.setTags(tags: tag.retailTags)
            }).disposed(by: disposeBag)

        tags.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)

        tags.connect()
            .disposed(by: disposeBag)

        rootView.searchTagsView.selectedTag
            .subscribe(onNext: { [unowned self] tag in
                self.rootView.searchBar.text = tag
                self.searchText.onNext(tag)
            }).disposed(by: disposeBag)

        rootView.searchBar.rx.text.unwrap()
            .subscribe(onNext: { [unowned self] text in
                if text == "" {
                    self.rootView.searchTagsView.clearAllTag()
                }
                self.searchText.onNext(text)
            })
            .disposed(by: disposeBag)
        rootView.tableView.isHidden = false
    }
}
