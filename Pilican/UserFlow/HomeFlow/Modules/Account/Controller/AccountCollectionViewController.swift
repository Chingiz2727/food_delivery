import UIKit
import RxSwift

class AccountViewController: ViewController, AccountModule, ViewHolder {
    typealias RootViewType = AccountView

    var myCardsDidTap: MyCardsDidTap?

    var myQRTapped: MyQRTapped?
    var changePasswordDidTap: ChangePasswordDidTap?

    var changePinTap: Callback?

    var editAccountDidSelect: EditAccountDidSelect?
    
    private let cache = DiskCache<String, Any>()
    private let disposeBag = DisposeBag()

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
                self.myCardsDidTap?()
            }).disposed(by: disposeBag)
            
        rootView.accountQR.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] _ in
                self.myQRTapped?()
            }).disposed(by: disposeBag)
        
        rootView.accountPassword.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                self.changePasswordDidTap?()
            }).disposed(by: disposeBag)
        ()

        rootView.accountKey.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                self.changePinTap?()
            }).disposed(by: disposeBag)
    
            rootView.accountHeaderView.editAccountButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.editAccountDidSelect?()
            }).disposed(by: disposeBag)
    }

    private func bindViewModel() {
        let user: User? = try? cache.readFromDisk(name: "userInfo")
        let profile: Profile? = try? cache.readFromDisk(name: "profileInfo")
        let name = profile?.firstName
        let phone = user?.username
        rootView.accountHeaderView.setData(name: name ?? "", phone: phone ?? "")
    }
}
