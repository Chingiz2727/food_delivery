import UIKit

final class HomeTabBarViewController: TabBarController, HomeTabBarModule {
    var accountTap: Callback?

    var qrCodeTap: Callback?

    var bonusTap: Callback?

    private let homeTabBar = HomeTabBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        tabBar.addSubview(homeTabBar)
        homeTabBar.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    override func setViewControllers(_ viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
    }
}
