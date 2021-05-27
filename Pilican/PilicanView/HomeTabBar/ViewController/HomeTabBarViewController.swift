import RxSwift
import UIKit

final class HomeTabBarViewController: TabBarController, HomeTabBarModule {
    var backTap: Callback?
    
    var accountTap: Callback?

    var qrCodeTap: Callback?

    var bonusTap: Callback?
    var notifyMenuTap: Callback?
    let homeTabBar = HomeTabBar()
    static let qrScanButton = QRButton()

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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
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
        view.addSubview(HomeTabBarViewController.qrScanButton)
        HomeTabBarViewController.qrScanButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalTo(homeTabBar.snp.top)
            make.size.equalTo(70)
        }
        navigationController?.navigationBar.isHidden = true
    }

    private func bindView() {

        HomeTabBarViewController.qrScanButton.control.rx.controlEvent(.touchUpInside)
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

    
    @objc private func handleBack() {
//        navigationController?.popViewController(animated: true)
        self.backTap?()
    }
}


extension UIViewController {
    public func addCustomizedNotifyBar() {
        NotificationCenter.default.addObserver(self, selector: #selector(changeBadge), name: NSNotification.Name(NotificationsString.handleBadge.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(removeBadge), name: NSNotification.Name(NotificationsString.removeBadge.rawValue), object: nil)
        let badgeNumber = UIApplication.shared.applicationIconBadgeNumber
        if badgeNumber > 0 {
            changeBadge()
        } else {
            removeBadge()
        }
    }
    
    @objc private func changeBadge() {
        let rightBar = UIBarButtonItem(
            image: Images.newAlarm.image?.withRenderingMode(.alwaysOriginal),
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
    
    @objc func showNotifyMenu() {
        NotificationCenter.default.post(name: NSNotification.Name(NotificationsString.openNotifications.rawValue), object: nil)
    }
}
