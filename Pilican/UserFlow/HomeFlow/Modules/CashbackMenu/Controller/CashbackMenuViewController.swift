//
//  CashbackMenuViewController.swift
//  Pilican
//
//  Created by kairzhan on 3/2/21.
//

import UIKit
import RxSwift

final class CashbackMenuViewController: UIViewController, ViewHolder, CashbackMenuModule {
    typealias RootViewType = CashbackMenuView
    
    var menuDidSelect: MenuDidSelect?

    private let disposeBag = DisposeBag()

    override func loadView() {
        view = CashbackMenuView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }

    private func bindView() {
        Observable.just(HomeCashbackMenu.allCases)
            .bind(to: rootView.tableView.rx.items(UITableViewCell.self)) { _, model, cell  in
                cell.textLabel?.text = model.rawValue
                cell.textLabel?.textAlignment = .center
                cell.selectionStyle = .none
                cell.textLabel?.font = .description1
            }
            .disposed(by: disposeBag)

        rootView.tableView.rx.itemSelected
            .withLatestFrom(Observable.just(HomeCashbackMenu.allCases)) { $1[$0.row] }
            .bind { [unowned self] item in
                self.menuDidSelect?(item)
            }.disposed(by: disposeBag)
    }
}
