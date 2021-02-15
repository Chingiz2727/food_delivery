import UIKit
import RxSwift

public final class IdPaginationAdapter<Page: IdPagination> {

  private let disposeBag = DisposeBag()

  private let manager: IdPaginationManager<Page>

  public init(manager: IdPaginationManager<Page>) {
    self.manager = manager
  }

  public func start() {
    manager.loadNextIfNeeded(retry: true)
  }

  public func restart() {
    manager.resetData()
  }

  public func connect(to tableView: UITableView) {
    let footer = tableView.tableFooterView as? PaginationTableFooterView
    let refresher = tableView.refreshControl

    tableView.rx.reachedBottom
      .subscribe(onNext: { [weak manager] in
        manager?.loadNextIfNeeded()
      })
      .disposed(by: disposeBag)

    refresher?.rx.controlEvent(.valueChanged)
      .subscribe(onNext: { [weak manager] in
        manager?.resetData()
      })
      .disposed(by: disposeBag)

    manager.stateChange
      .filter { !$0.isLoading }
      .subscribe(onNext: { _ in
        refresher?.endRefreshing()
      })
      .disposed(by: disposeBag)

    manager.stateChange
      .subscribe(onNext: { state in
        footer?.configure(state: state)
      })
      .disposed(by: disposeBag)

    footer?.retryButton.rx.tap
      .subscribe(onNext: { [weak manager] in
        manager?.loadNextIfNeeded(retry: true)
      })
      .disposed(by: disposeBag)
  }
}
