import RxSwift
import UIKit

final class HomeTabBarViewController: TabBarController, HomeTabBarModule {
    var accountTap: Callback?

    var qrCodeTap: Callback?

    var bonusTap: Callback?
    var notifyMenuTap: Callback?
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

    override var navigationBarHidden: Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupInitialLayout()
        bindView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: Images.alarm.image?.withRenderingMode(.alwaysOriginal),
            style: .done,
            target: self,
            action: #selector(showNotifyMenu))
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

        tabView.balanceInfoView.control.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                self.bonusTap?()
            })
            .disposed(by: disposeBag)

        tabView.userInfoView.control.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                self.accountTap?()
            })
            .disposed(by: disposeBag)
        tabView.setData(profile: userInfoStorage.fullName ?? "", balance: String(userInfoStorage.balance ?? 0))
    }
    
    @objc private func showNotifyMenu() {
        self.notifyMenuTap?()
    }
}
