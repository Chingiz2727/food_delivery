//
//  OrderHistoryViewController.swift
//  Pilican
//
//  Created by kairzhan on 4/17/21.
//

import UIKit
import RxSwift

final class OrderHistoryViewController: ViewController, ViewHolder, OrderHistoryModule {
    var selectedOrderHistory: SelectedOrderHistory?
    
    typealias RootViewType = OrderHistoryView

    var onSelectOrderHistory: OnSelectOrderHistory?

    private let viewModel: OrderHistoryViewModel
    private let disposeBag = DisposeBag()
    private let dishList: DishList

    init(viewModel: OrderHistoryViewModel, dishList: DishList) {
        self.viewModel = viewModel
        self.dishList = dishList
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
        rootView.tableView.estimatedRowHeight = UITableView.automaticDimension

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
            .bind(to: rootView.tableView.rx.items(OrderHistoryTableViewCell.self)) { row, model, cell in
                cell.setData(data: model)
                cell.onTryTap = { [unowned self] tag in
                    if tag != 2 {
                        if model.retailId ?? 0 != self.dishList.retail?.id && !dishList.products.isEmpty {
                            self.showBasketAlert {
                                self.dishList.products = []
                                self.dishList.wishDishList.onNext([])
                                self.selectedOrderHistory?(dishList, .delivery)
                            }
                        } else {
                            let product: [Product] = model.orderItems!.map { item in
                                // swiftlint:disable line_length
                                return Product.init(status: item.dish?.status ?? 0, img: item.dish?.img, id: item.dish?.id ?? 0, price: item.dish?.price ?? 0, composition: item.dish?.composition ?? "", age_access: item.dish?.age_access ?? 0, name: item.dish?.name ?? "", shoppingCount: item.dish?.shoppingCount)
                            }
                            let retail = DeliveryRetail(id: model.retailId ?? 0, cashBack: 0, isWork: 1, longitude: model.longitude ?? 0, latitude: model.latitude ?? 0, dlvCashBack: 0, pillikanDelivery: 0, logo: model.retailLogo ?? "", address: model.retailAdress ?? "", workDays: [], payIsWork: 0, name: model.retailName ?? "", status: model.retailStatus ?? 0, rating: model.retailRating)
                            self.dishList.products = product
                            self.dishList.retail = retail
                            self.selectedOrderHistory?(dishList, .delivery)
                        }
                    } else {
                        self.onSelectOrderHistory?(model, tag)
                    }
                }
                cell.contentView.isUserInteractionEnabled = false
            }.disposed(by: disposeBag)

        orderHistory.connect()
            .disposed(by: disposeBag)

        rootView.tableView.rx.itemSelected
          .subscribe(onNext: { [weak self] indexPath in
            let cell = self?.rootView.tableView.cellForRow(at: indexPath) as? OrderHistoryTableViewCell
            cell?.isExpanded = !cell!.isExpanded
            self?.rootView.tableView.beginUpdates()
            self?.rootView.tableView.endUpdates()
          })
            .disposed(by: disposeBag)
    }
}
