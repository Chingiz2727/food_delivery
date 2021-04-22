import RxSwift
import UIKit

class ItemSearchViewController: SearchViewController, ItemSearchModule {
    var onDeliveryRetailCompanyDidSelect: OnDeliveryCompanyDidSelect?

    private let viewModel: ItemSearchViewMoodel
    private let disposeBag = DisposeBag()

    init(viewModel: ItemSearchViewMoodel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        rootView.tableView.registerClassForCell(DeliveryRetailListTableViewCell.self)
        bindViewModel()
    }

    private func bindViewModel() {
        let output = viewModel.transform(input: .init(text: rootView.searchBar.rx.text.unwrap()))
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

        Observable.combineLatest(retailList.element, rootView.tableView.rx.itemSelected)
            .subscribe(onNext: { [unowned self] model, path in
                self.onDeliveryRetailCompanyDidSelect?(model.retails.content[path.row])
            })
            .disposed(by: disposeBag)

        retailList.connect()
            .disposed(by: disposeBag)

        rootView.tableView.isHidden = false
    }
}
