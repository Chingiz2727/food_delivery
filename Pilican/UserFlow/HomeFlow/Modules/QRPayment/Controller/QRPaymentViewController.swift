//
//  QRPaymentViewController.swift
//  Pilican
//
//  Created by kairzhan on 3/25/21.
//

import UIKit
import RxSwift

class QRPaymentViewController: ViewController, ViewHolder, QRPaymentModule {
    var closeButton: CloseButton?
    
    var openSuccessPayment: OpenSuccesPayment?
    
    typealias RootViewType = QRPaymentView

    private let cache = DiskCache<String, Any>()
    private let disposeBag = DisposeBag()
    private let viewModel: QRPaymentViewModel
    private let orderIdSubject = BehaviorSubject<String>(value: "")
    private let createdAtSubject = BehaviorSubject<String>(value: "")
    private let sigSubject = BehaviorSubject<String>(value: "")
    private let epayAmountSubject = BehaviorSubject<Double>(value: 0.0)
    private let priceSubject = BehaviorSubject<Double>(value: 0.0)
    private var epayAmount = 0
    private var price = 0
    private var cashback = 0
    private let userInfo: UserInfoStorage
    private var textPrice: String?
    private let analytics = assembler.resolver.resolve(PillicanAnalyticManager.self)!
    init(viewModel: QRPaymentViewModel, userInfo: UserInfoStorage, textPrice: String?) {
        self.viewModel = viewModel
        self.userInfo = userInfo
        self.textPrice = textPrice
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = QRPaymentView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        analytics.log(.cafepay)
        bindView()
        bindViewModel()
        if let textPrice = textPrice {
            rootView.priceView.priceTextField.text = textPrice
            self.price = Int(textPrice)!
            self.priceSubject.onNext(Double(textPrice)!)
            let amount = self.calculateCashback(isOn: false, amount: textPrice)
            rootView.priceView.setData(cashback: amount.0)
            rootView.calculatePayView.setData(cardValue: amount.1, cashbackValue: amount.2)
        }
        title = "Оплата"
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
    }

    private func bindView() {
        rootView.retailView.setRetail(retail: viewModel.info.retail)
        guard let balance = userInfo.balance else { return }
        rootView.paymentChoiceView.setData(cashback: String(balance))
        rootView.commentView.setData(img: viewModel.info.retail.imgLogo ?? "")
        Observable.combineLatest(
            rootView.paymentChoiceView.choiceSwitch.rx.isOn.asObservable(),
            rootView.priceView.priceTextField.rx.text.asObservable())
            .subscribe(onNext: { [unowned self] isOn, amount in
                self.toggleSwitch(sender: isOn)
                self.price = Int(amount ?? "0") ?? 0
                self.priceSubject.onNext(Double(price))
                let amount = self.calculateCashback(isOn: isOn, amount: amount)
                rootView.priceView.setData(cashback: amount.0)
                rootView.calculatePayView.setData(cardValue: amount.1, cashbackValue: amount.2)
            })
            .disposed(by: disposeBag)
    }

    private func bindViewModel() {
        let output = viewModel.transform(input: QRPaymentViewModel.Input(
                                            payTapped: rootView.payButton.rx.tap.asObservable(),
                                            amount: priceSubject,
                                            epayAmount: epayAmountSubject,
                                            comment: rootView.commentView.commentTextField.rx.text.asObservable(),
                                            loadInfo: .just(())))
        
        let scan = output.scanRetailResponse.publish()
        
        scan.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)
        
        scan.element
            .subscribe(onNext: { [unowned self] scan in
                viewModel.info.orderId = scan.orderId
                viewModel.info.type = scan.type
            }).disposed(by: disposeBag)
        
        scan.connect()
            .disposed(by: disposeBag)

        let result = output.payByQRPartnerResponse.publish()

        result.element
            .subscribe(onNext: { [unowned self] result in
                if result.status == 200 {
                    userInfo.balance = result.user.balance
                    openSuccessPayment?(viewModel.info.retail, price, cashback)
                }
            }).disposed(by: disposeBag)

        result.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)
        
        result.loading
            .bind(to: ProgressView.instance.rx.loading)
            .disposed(by: disposeBag)
        
        result.connect()
            .disposed(by: disposeBag)
    }

    private func toggleSwitch(sender: Bool) {
        if sender {
            rootView.calculatePayView.isHidden = false
            rootView.paymentChoiceView.choiceSwitch.thumbTintColor = .primary
        } else {
            rootView.calculatePayView.isHidden = true
            rootView.paymentChoiceView.choiceSwitch.thumbTintColor = .pilicanLightGray
            epayAmount = price
        }
    }

    private func calculateCashback(isOn: Bool, amount: String?) -> (String, String, String) {
        var myBonus = 0
        if let balance = userInfo.balance {
            myBonus = balance
        }
        
        guard let intAmount = Int(amount ?? "0") else { return ("0", "0", "0") }
        let payAmount = isOn ? intAmount - myBonus : intAmount
        let totalAmount = payAmount < 0 ? 0 : payAmount
        let cashBack = (totalAmount * (viewModel.info.retail.cashBack ?? 1) / 100)
        cashback = cashBack
        var amountByBonus: Int = 0
        if isOn {
            amountByBonus = payAmount - myBonus < 0 ? 0 : payAmount - myBonus
        } else {
            amountByBonus = intAmount
        }
        let spendBonusAmount = myBonus > intAmount ? intAmount : myBonus
        epayAmount = amountByBonus

        epayAmountSubject.onNext(Double(epayAmount))
        return (String(cashBack), String(amountByBonus), String(spendBonusAmount))
    }
    
    override func customBackButtonDidTap() {
        closeButton?()
    }
}
