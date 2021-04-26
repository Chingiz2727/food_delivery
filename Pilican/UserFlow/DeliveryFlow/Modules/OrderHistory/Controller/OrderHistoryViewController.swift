//
//  OrderHistoryViewController.swift
//  Pilican
//
//  Created by kairzhan on 4/17/21.
//

import UIKit
import RxSwift

final class OrderHistoryViewController: ViewController, ViewHolder, OrderHistoryModule {
    typealias RootViewType = OrderHistoryView

    var onSelectOrderHistory: OnSelectOrderHistory?

    private let viewModel: OrderHistoryViewModel
    private let disposeBag = DisposeBag()
    
    init(viewModel: OrderHistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = OrderHistoryView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }

    private func bindView() {
        rootView.tableView.registerClassForCell(OrderHistoryTableViewCell.self)
        rootView.tableView.separatorInset = .init(top: 0, left: 0, bottom: 10, right: 0)

        let output = viewModel.transform(input: .init(loadOrderHistory: .just(())))

        let orderHistory = output.payHistory.publish()

        let adapter = viewModel.adapter
        adapter.connect(to: rootView.tableView)
        adapter.start()

        orderHistory.loading
            .bind(to: ProgressView.instance.rx.loading)
            .disposed(by: disposeBag)

        orderHistory.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)

        orderHistory.element
            .bind(to: rootView.tableView.rx.items(OrderHistoryTableViewCell.self)) { _, model, cell in
                cell.setData(data: model)
            }.disposed(by: disposeBag)

        orderHistory.connect()
            .disposed(by: disposeBag)

        rootView.tableView.rx.itemSelected
            .withLatestFrom(orderHistory.element) { $1[$0.row] }
            .bind { [unowned self] orderHistory in
                self.onSelectOrderHistory?(orderHistory)
            }.disposed(by: disposeBag)
    }
}
