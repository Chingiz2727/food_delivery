import RxSwift
import UIKit

class HomeViewController: ViewController, HomeModule, ViewHolder {
    typealias RootViewType = HomeView

    private let viewModel: HomeViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func loadView() {
        view = HomeView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        bindViewModel()
    }

    private func bindView() {
        rootView.tableView.setSizedHeaderView(rootView.headerView)
        rootView.tableView.registerClassForCell(RetailTableViewCell.self)
    }

    private func bindViewModel() {
        let output = viewModel.transform(input: .init(viewDidLoad: Observable.merge(.just(()))))

        let slider = output.slider.publish()
        let retailList = output.retailList.publish()

        slider.element
            .subscribe(onNext: { [unowned self] slider in

            })
            .disposed(by: disposeBag)

        slider.connect()
            .disposed(by: disposeBag)

        retailList.element
            .map { $0.retailList ?? [] }
            .bind(to: rootView.tableView.rx.items(RetailTableViewCell.self)) { _, model, cell in
                cell.setRetail(retail: model)
            }.disposed(by: disposeBag)

        retailList.loading
            .bind(to: ProgressView.instance.rx.loading)
            .disposed(by: disposeBag)

        retailList.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)

        retailList.connect()
            .disposed(by: disposeBag)
    }
}
