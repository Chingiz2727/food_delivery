//
//  OrderHistoryViewController.swift
//  Pilican
//
//  Created by kairzhan on 4/17/21.
//

import UIKit
import CoreLocation
import RxSwift

final class OrderHistoryViewController: ViewController, ViewHolder, OrderHistoryModule {
    var remakeOrder: RemakeOrder?
    
    var selectedOrderHistory: SelectedOrderHistory?
    
    typealias RootViewType = OrderHistoryView

    var onSelectOrderHistory: OnSelectOrderHistory?

    private let viewModel: OrderHistoryViewModel
    private let disposeBag = DisposeBag()
    private let locationManager = CLLocationManager()
    private var location: CLLocationCoordinate2D?
    private let dishList: DishList
    private let analytic = assembler.resolver.resolve(PillicanAnalyticManager.self)!
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
        locationManager.delegate = self
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
                    if tag == 6 {
                        self.goToTryOrder(order: model)
                    } else {
                        self.analytic.log(.orderagain)
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
        location = locationManager.location?.coordinate
    }
    
    private func goToTryOrder(order: DeliveryOrderResponse) {
        if order.retail?.isWork == 0 {
            showErrorInAlert(text: "Заведение сейчас не работает")
        } else {
            dishList.wishDishList.onNext([])
            let dishList = assembler.resolver.resolve(DishList.self)!
            let products = dishList.orderItemsToProduct(items: order.orderItems ?? [])
            dishList.products = products
            dishList.wishDishList.onNext(products)
            dishList.retail = order.retail
            guard let location = location else {
                self.showErrorInAlert(text: "Дайте доступ к вашему местоположению")
                return
            }
            self.remakeOrder?(.delivery, location)
        }
    }
}

extension OrderHistoryViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedAlways,.authorizedWhenInUse:
            let location = manager.location?.coordinate
            self.location = location
        default:
            break
        }
    }
}
