protocol HomeTabBarModule: TabBarModule {
    var accountTap: Callback? { get set }
    var qrCodeTap: Callback? { get set }
    var bonusTap: Callback? { get set }
    var notifyMenuTap: Callback? { get set }
    var backTap: Callback? { get set }
}
