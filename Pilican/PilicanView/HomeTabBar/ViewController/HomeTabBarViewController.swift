import RxSwift
import UIKit

final class HomeTabBarViewController: TabBarController, HomeTabBarModule {
    var accountTap: Callback?

    var qrCodeTap: Callback?

    var bonusTap: Callback?

    private let homeTabBar = HomeTabBar()
    private let tabView = HomeTabView()
    private let userInfoStorage: UserInfoStorage
    
    private let disposeBag = DisposeBag()

    init(userInfoStorage: UserInfoStorage) {
        self.userInfoStorage = userInfoStorage
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialLayout()
        bindView()
    }

    override func setViewControllers(_ viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
    }

    private func setupInitialLayout() {
        setValue(homeTabBar, forKey: "tabBar")
        view.addSubview(tabView)
        tabView.snp.makeConstraints { $0.edges.equalTo(homeTabBar) }
    }

    private func bindView() {
        tabView.qrScanButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.qrCodeTap?()
            })
            .disposed(by: disposeBag)

        tabView.balanceInfoView.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                self.bonusTap?()
            })
            .disposed(by: disposeBag)

        tabView.userInfoView.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                self.accountTap?()
            })
            .disposed(by: disposeBag)
        tabView.setData(profile: userInfoStorage.fullName ?? "", balance: String(userInfoStorage.balance ?? 0))
    }
}
