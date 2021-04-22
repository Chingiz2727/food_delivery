//
//  DeliveryMenuViewController.swift
//  Pilican
//
//  Created by kairzhan on 4/16/21.
//

import UIKit
import RxSwift

final class DeliveryMenuViewController: UIViewController, ViewHolder, DeliveryMenuModule {
    var deliveryMenuDidSelect: DeliveryMenuDidSelect?
    
    typealias RootViewType = DeliveryMenuView

    private let disposeBag = DisposeBag()

    override func loadView() {
        view = DeliveryMenuView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }

    private func bindView() {
        Observable.just(DeliveryMenu.allCases)
            .bind(to: rootView.tableView.rx.items(UITableViewCell.self)) { _, model, cell  in
                cell.textLabel?.text = model.rawValue
                cell.textLabel?.textAlignment = .center
                cell.selectionStyle = .none
                cell.textLabel?.font = .description1
            }
            .disposed(by: disposeBag)

        rootView.tableView.rx.itemSelected
            .withLatestFrom(Observable.just(DeliveryMenu.allCases)) { $1[$0.row] }
            .bind { [unowned self] item in
                self.deliveryMenuDidSelect?(item)
            }.disposed(by: disposeBag)
    }
}
