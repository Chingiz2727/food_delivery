protocol HomeTabBarModule: TabBarModule {
    var accountTap: Callback? { get set }
    var qrCodeTap: Callback? { get set }
    var bonusTap: Callback? { get set }
}
