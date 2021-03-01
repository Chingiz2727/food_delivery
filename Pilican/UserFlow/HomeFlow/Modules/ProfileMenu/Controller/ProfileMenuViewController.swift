import RxSwift
import UIKit

final class ProfileMenuViewController: UIViewController, ViewHolder, ProfileMenuModule {
    typealias RootViewType = ProfileMenuView

    var menuDidSelect: MenuDidSelect?

    private let disposeBag = DisposeBag()

    override func loadView() {
        view = ProfileMenuView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }

    private func bindView() {
        Observable.just(HomeProfileMenu.allCases)
            .bind(to: rootView.tableView.rx.items(UITableViewCell.self)) { _, model, cell  in
                cell.textLabel?.text = model.rawValue
                cell.textLabel?.textAlignment = .center
                cell.selectionStyle = .none
                cell.textLabel?.font = .description1
            }
            .disposed(by: disposeBag)

        rootView.tableView.rx.itemSelected
            .withLatestFrom(Observable.just(HomeProfileMenu.allCases)) { $1[$0.row] }
            .bind { [unowned self] item in
                self.menuDidSelect?(item)
            }.disposed(by: disposeBag)
    }
}
