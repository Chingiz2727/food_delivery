//
//  BalanceViewController.swift
//  Pilican
//
//  Created by kairzhan on 3/17/21.
//
import RxSwift
import UIKit

class BalanceViewController: ViewController, ViewHolder, BalanceModule {
    var closeButton: CloseButton?
    var dissmissBalanceModule: DissmissBalanceModule?
    
    typealias RootViewType = BalanceView
    
    private let disposeBag = DisposeBag()
    private let viewModel: BalanceViewModel
    private let userInfoStorage: UserInfoStorage
    
    init(viewModel: BalanceViewModel, userInfoStorage: UserInfoStorage) {
        self.viewModel = viewModel
        self.userInfoStorage = userInfoStorage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = BalanceView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        title = "Пополнение"
        navigationController?.navigationBar.isHidden = false
        addCustomizedNotifyBar()
    }

    private func bindView() {
        if userInfoStorage.isCard == 0 {
            rootView.addCardButton.isHidden = false
            rootView.replishmentButton.isHidden = true
        }
        let output = viewModel.transform(
            input: .init(
                replenishTapped: rootView.replishmentButton.rx.tap.asObservable(),
                amount: rootView.enterBalanceTextField.rx.text.unwrap().asObservable()))
    
        let result = output.result.publish()

        result.element
            .subscribe(onNext: { [unowned self] result in
                self.userInfoStorage.balance = result.user.balance
                self.userInfoStorage.updateInfo.onNext(())
                self.showSuccessMessageAlert(message: "Вы успешно пополнили баланс на сумму ₸ \(rootView.enterBalanceTextField.text ?? "0")") {
                    self.navigationController?.popViewController(animated: true)
                    self.dissmissBalanceModule?()
                }
            }).disposed(by: disposeBag)

        result.loading
            .bind(to: ProgressView.instance.rx.loading)
            .disposed(by: disposeBag)
        result.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)

        result.connect()
            .disposed(by: disposeBag)
    }

    override func customBackButtonDidTap() {
        closeButton?()
    }
}
