//
//  PayDetailViewController.swift
//  Pilican
//
//  Created by kairzhan on 3/18/21.
//

import UIKit
import RxSwift

class PayDetailViewController: ViewController, ViewHolder, PayDetailModule {
    typealias RootViewType = PayDetailView
    
    private let disposeBag = DisposeBag()
    private let payments: Payments

    init(payments: Payments) {
        self.payments = payments
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = PayDetailView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }

    private func bindView() {
        rootView.setData(data: payments)
    }
}
