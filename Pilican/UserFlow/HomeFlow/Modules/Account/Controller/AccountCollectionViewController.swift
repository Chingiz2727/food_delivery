import UIKit
import RxSwift

class AccountViewController: ViewController, AccountModule, ViewHolder {
    var closeButton: CloseButton?
    
    var profileItemsDidSelect: ProfileItemsDidSelect?

    typealias RootViewType = AccountView

    private let disposeBag = DisposeBag()
    private let userInfoStorage: UserInfoStorage
    
    init(userInfoStorage: UserInfoStorage) {
        self.userInfoStorage = userInfoStorage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = AccountView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        bindViewModel()
    }

    private func bindView() {
        rootView.accountCard.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                self.profileItemsDidSelect?(.myCards)
            }).disposed(by: disposeBag)

        rootView.accountQR.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] _ in
                self.profileItemsDidSelect?(.myQR)
            }).disposed(by: disposeBag)

        rootView.accountPassword.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                self.profileItemsDidSelect?(.changePassword)
            }).disposed(by: disposeBag)
        ()

        rootView.accountKey.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                self.profileItemsDidSelect?(.changePin)
            }).disposed(by: disposeBag)

            rootView.accountHeaderView.editAccountButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.profileItemsDidSelect?(.editAccount)
            }).disposed(by: disposeBag)

        rootView.existButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.profileItemsDidSelect?(.logout)
            }).disposed(by: disposeBag)
    }

    override func customBackButtonDidTap() {
        self.closeButton?()
    }

    private func bindViewModel() {
        userInfoStorage.updateInfo
            .subscribe(onNext: { [unowned self] in
                self.updateProfile()
            })
            .disposed(by: disposeBag)
    }
    
    private func updateProfile() {
        let name = userInfoStorage.fullName
        let phone = userInfoStorage.mobilePhoneNumber
        rootView.accountHeaderView.setData(name: name ?? "", phone: phone ?? "")
    }
}
