import RxSwift
import UIKit

final class CashBackListViewController: ViewController, ViewHolder, CashBackListModule {

    typealias RootViewType = CashBackListView

    var onSelectRetail: OnSelectRetail?

    private let viewModel: CashBackListViewModel
    private let disposeBag = DisposeBag()
    private let dataSource = CashBackListDataSource()
    private let itemSubject = BehaviorSubject<Int>(value: 1)

    init(viewModel: CashBackListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func loadView() {
        view = CashBackListView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        bindViewModel()
    }

    private func bindView() {
        rootView.tableView.setSizedHeaderView(rootView.headerView)
        rootView.tableView.setSizedFooterView(rootView.footerView)
        rootView.tableView.registerClassForCell(CashBackListTableViewCell.self)
        rootView.tableView.separatorStyle = .none
    }

    private func bindViewModel() {
        let output = viewModel.transform(input: .init(loadByCategoryId: itemSubject))

        let retailList = output.retailList.publish()

        let adapter = viewModel.adapter
        adapter.connect(to: rootView.tableView)
        adapter.start()

        retailList.loading
            .bind(to: ProgressView.instance.rx.loading)
            .disposed(by: disposeBag)

        retailList.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)

        retailList.element
            .bind(to: rootView.tableView.rx.items(CashBackListTableViewCell.self)) { _, model, cell in
                cell.setRetail(retail: model)
            }
            .disposed(by: disposeBag)

        rootView.tableView.rx.itemSelected
            .withLatestFrom(retailList.element) { $1[$0.row] }
            .bind { [unowned self] retail in
                self.onSelectRetail?(retail)
            }
            .disposed(by: disposeBag)

        retailList.connect()
            .disposed(by: disposeBag)

        rootView.headerView.foodCategory.control.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                self.itemSubject.onNext(1)
            }).disposed(by: disposeBag)

        rootView.headerView.servicesCategory.control.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                self.itemSubject.onNext(3)
            }).disposed(by: disposeBag)

        rootView.headerView.salesCategory.control.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                self.itemSubject.onNext(2)
            }).disposed(by: disposeBag)

        rootView.headerView.entertainmentCategory.control.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                self.itemSubject.onNext(4)
            }).disposed(by: disposeBag)
    }
}
