import RxSwift
import UIKit

final class HomeTabBarViewController: TabBarController, HomeTabBarModule {
    var accountTap: Callback?

    var qrCodeTap: Callback?

    var bonusTap: Callback?

    private let homeTabBar = HomeTabBar()
    private let tabView = HomeTabView()

    private let disposeBag = DisposeBag()

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
//                self.qrCodeTap?()
            })
            .disposed(by: disposeBag)

        tabView.balanceInfoView.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                print("Tap balance")
                self.bonusTap?()
            })
            .disposed(by: disposeBag)

        tabView.userInfoView.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                print("Tap account")
                self.accountTap?()
            })
            .disposed(by: disposeBag)
    }
}
