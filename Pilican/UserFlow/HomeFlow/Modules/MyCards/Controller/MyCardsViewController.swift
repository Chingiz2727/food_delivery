//
//  MyCardsViewController.swift
//  Pilican
//
//  Created by kairzhan on 3/16/21.
//

import UIKit
import RxSwift

final class MyCardsViewController: UIViewController, ViewHolder, MyCardsModule {
    typealias RootViewType = MyCardsView
    
    private let disposeBag = DisposeBag()

    override func loadView() {
        view = MyCardsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }

    private func bindView() {
        rootView.tableView.setSizedFooterView(rootView.footerView)
        rootView.tableView.registerClassForCell(MyCardsTableViewCell.self)
        rootView.tableView.separatorStyle = .none
    }
}
