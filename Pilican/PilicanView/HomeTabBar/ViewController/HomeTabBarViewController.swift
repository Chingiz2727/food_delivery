import RxSwift
import UIKit

final class HomeTabBarViewController: TabBarController, HomeTabBarModule {
    var backTap: Callback?
    
    var accountTap: Callback?

    var qrCodeTap: Callback?

    var bonusTap: Callback?
    var notifyMenuTap: Callback?
    let homeTabBar = HomeTabBar()
    let qrScanButton = QRButton()

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
        NotificationCenter.default.addObserver(self, selector: #selector(changeBadge), name: NSNotification.Name(NotificationsString.handleBadge.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeBadge), name: NSNotification.Name(NotificationsString.removeBadge.rawValue), object: nil)
        let badgeNumber = UIApplication.shared.applicationIconBadgeNumber
        if badgeNumber > 0 {
            changeBadge()
        } else {
            removeBadge()
        }
    }

    override func setViewControllers(_ viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
    }

    @objc private func changeBadge() {
        let rightBar = UIBarButtonItem(
            image: Images.notifyAlarm.image?.withRenderingMode(.alwaysOriginal),
            style: .done,
            target: self,
            action: #selector(showNotifyMenu))
        navigationItem.rightBarButtonItem = rightBar
    }
    
    @objc private func removeBadge() {
        let rightBar = UIBarButtonItem(
            image: Images.alarm.image?.withRenderingMode(.alwaysOriginal),
            style: .done,
            target: self,
            action: #selector(showNotifyMenu))
        navigationItem.rightBarButtonItem = rightBar
    }
    
    private func setupInitialLayout() {
        setValue(homeTabBar, forKey: "tabBar")
        view.addSubview(qrScanButton)
        qrScanButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(homeTabBar.snp.top)
            make.size.equalTo(70)
        }
    }

    private func bindView() {

        qrScanButton.control.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                self.qrCodeTap?()
            })
            .disposed(by: disposeBag)

        homeTabBar.tabView.balanceInfoView.control.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                self.bonusTap?()
            })
            .disposed(by: disposeBag)

        homeTabBar.tabView.userInfoView.control.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                self.accountTap?()
            })
            .disposed(by: disposeBag)
        
        userInfoStorage.updateInfo
            .subscribe(onNext: { [unowned self] in
                self.homeTabBar.tabView.setData(profile: userInfoStorage.fullName ?? "", balance: String(userInfoStorage.balance ?? 0))
            }).disposed(by: disposeBag)
    }

    @objc private func showNotifyMenu() {
        self.notifyMenuTap?()
    }
    
    @objc private func handleBack() {
//        navigationController?.popViewController(animated: true)
        self.backTap?()
    }
}
