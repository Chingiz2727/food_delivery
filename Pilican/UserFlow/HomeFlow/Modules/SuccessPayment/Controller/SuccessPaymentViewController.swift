//
//  SuccessPaymentViewController.swift
//  Pilican
//
//  Created by kairzhan on 3/29/21.
//

import Foundation
import RxSwift

class SuccessPaymentViewController: ViewController, ViewHolder, SuccessPaymentModule {
    var nextTapped: NextTapped?
    
    typealias RootViewType = SuccessPaymentView

    private let retail: Retail
    private var price: Int
    private var cashback: Int
    private let disposeBag = DisposeBag()

    override func loadView() {
        view = SuccessPaymentView()
    }

    init(retail: Retail, price: Int, cashback: Int) {
        self.retail = retail
        self.price = price
        self.cashback = cashback
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    private func bindView() {
        rootView.retailView.setRetail(retail: retail)
        rootView.setData(price: String(price), cashback: String(cashback))
        rootView.nextButton.rx.tap
            .subscribe(onNext: { [unowned self] in
//                self.nextTapped?()
                self.navigationController?.popToRootViewController(animated: true)
            }).disposed(by: disposeBag)
    }
}
