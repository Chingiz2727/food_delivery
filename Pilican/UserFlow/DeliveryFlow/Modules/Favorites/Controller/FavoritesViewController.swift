//
//  FavoritesViewController.swift
//  Pilican
//
//  Created by kairzhan on 4/16/21.
//

import UIKit
import RxSwift

class FavoritesViewController: ViewController, ViewHolder, FavoritesModule {
    var onRetailDidSelect: OnRetailDidSelect?

    typealias RootViewType = FavoritesView

    override func loadView() {
        view = FavoritesView()
    }

    private let viewModel: FavoritesViewModel
    private let disposeBag = DisposeBag()

    init(viewModel: FavoritesViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }

    private func bindView() {
        let output = viewModel.transform(input: .init(loadFavorites: .just(())))

        let favorites = output.retailList.publish()

        let adapter = viewModel.adapter
        adapter.connect(to: rootView.tableView)
        adapter.start()

        favorites.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)

        favorites.element
            .bind(to: rootView.tableView.rx.items(DeliveryRetailListTableViewCell.self)) { [unowned self] _, model, cell in
                cell.setRetail(retail: model)
            }.disposed(by: disposeBag)

        rootView.tableView.rx.itemSelected
            .withLatestFrom(favorites.element) { $1[$0.row] }
            .bind { [unowned self] retail in
                self.onRetailDidSelect?(retail)
            }.disposed(by: disposeBag)

        favorites.connect()
            .disposed(by: disposeBag)
    }
}
