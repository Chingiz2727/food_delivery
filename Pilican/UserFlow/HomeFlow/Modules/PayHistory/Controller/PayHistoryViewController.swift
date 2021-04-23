//
//  PayHistoryViewController.swift
//  Pilican
//
//  Created by kairzhan on 3/17/21.
//

import UIKit
import RxSwift

final class PayHistoryViewController: ViewController, ViewHolder, PayHistoryModule {
    var closeButton: CloseButton?
    
    var onSelectPayHistory: OnSelectPayHistory?
    
    typealias RootViewType = PayHistoryView
    
    private let viewModel: PayHistoryViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: PayHistoryViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = PayHistoryView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        bindViewModel()
    }

    private func bindView() {
        rootView.tableView.registerClassForCell(PayHistoryTableViewCell.self)
        rootView.tableView.separatorInset = .init(top: 0, left: 0, bottom: 1, right: 0)
    }

    private func bindViewModel() {
        let output = viewModel.transform(input: .init(loadPayHistory: .just(())))

        let payHistory = output.payHistory.publish()

        let adapter = viewModel.adapter
        adapter.connect(to: rootView.tableView)
        adapter.start()

        payHistory.loading
            .bind(to: ProgressView.instance.rx.loading)
            .disposed(by: disposeBag)

        payHistory.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)

        payHistory.element
            .bind(to: rootView.tableView.rx.items(PayHistoryTableViewCell.self)) { _, model, cell in
                cell.setData(data: model)
            }.disposed(by: disposeBag)

        payHistory.connect()
            .disposed(by: disposeBag)

        rootView.tableView.rx.itemSelected
            .withLatestFrom(payHistory.element) { $1[$0.row] }
            .bind { [unowned self] payHistory in
                self.onSelectPayHistory?(payHistory)
            }.disposed(by: disposeBag)
    }
    
    override func customBackButtonDidTap() {
        closeButton?()
    }
}
