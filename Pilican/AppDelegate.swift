import UIKit
import Swinject
import Kingfisher
import Firebase
import IQKeyboardManagerSwift
import Messages
import YandexMapsMobile

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let assembler = Assembler([DependencyContainerAssembly()])
    private var appCoordinator: AppCoordinator?
    private var deepLinkActionFactory: DeepLinkActionFactory?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupWindow()
        setupKeyboardManager()
        setupNavigationBar()
        setupKingfisher()
        setupFirebase()
        #if DEBUG
        LoggerConfigurator.configure()
        #endif
        YMKMapKit.setApiKey("7b4d5f85-da95-462c-a67c-61a2f218cc13")
        
        guard let rootController = application.windows.first?.rootViewController as? CoordinatorNavigationController else {
            fatalError("rootViewController must be CoordinatorNavigationController")
        }
        appCoordinator = AppCoordinator(router: Router(rootController: rootController), container: assembler.resolver)
        deepLinkActionFactory = assembler.resolver.resolve(DeepLinkActionFactory.self)
        assembler.resolver.resolve(PushNotificationManager.self)?.setCoordinatorToEngine(coordinator: appCoordinator!)
        assembler.resolver.resolve(AuthStateObserver.self)!.setCoordinator(appCoordinator)
        if let pushNotificationInfo = launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable: Any],
           let deepLinkAction = deepLinkActionFactory?.getNotificationDeepLinkAction(from: pushNotificationInfo) {
            appCoordinator?.start(with: deepLinkAction)
        } else {
            appCoordinator?.start()
        }
        return true
    }

    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = .white
        window?.rootViewController = CoordinatorNavigationController(backBarButtonImage: nil)
    }

    func makeCoordinator(application: UIApplication) {
        guard let rootController = application.windows.first?.rootViewController as? CoordinatorNavigationController else {
            fatalError("rootViewController must be CoordinatorNavigationController")
        }

        appCoordinator = AppCoordinator(router: Router(rootController: rootController), container: assembler.resolver)
        assembler.resolver.resolve(AuthStateObserver.self)!.setCoordinator(appCoordinator)
        appCoordinator?.start()
    }

    private func setupKeyboardManager() {
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.previousNextDisplayMode = .alwaysHide
        IQKeyboardManager.shared.shouldShowToolbarPlaceholder = false
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarTintColor = .primary
    }

    private func setupKingfisher() {
        let cache = ImageCache.default
        cache.memoryStorage.config.expiration = .seconds(30)
        cache.diskStorage.config.expiration = .days(2)
        cache.memoryStorage.config.totalCostLimit = getMB(10)
    }

    private func setupNavigationBar() {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.titleTextAttributes = Constants.titleTextAttributes
        navigationBar.tintColor = .pilicanBlack
        UIBarButtonItem.appearance().setBackButtonTitlePositionAdjustment(UIOffset(horizontal: -1000, vertical: 0), for:UIBarMetrics.default)
        navigationBar.barTintColor = .pilicanWhite
    }

    private func getMB(_ value: Int) -> Int {
        return value * 1024 * 1024
    }
    
    private func configureFirebase() {
        let options = FirebaseOptions(
            googleAppID: "1:965585821604:ios:b11b7d21d3c60d15c36b31", gcmSenderID: "965585821604")
        options.bundleID = "com.wezom.Pillikan"
        options.apiKey = "AIzaSyBFSa125L3_r3K5BBDh1Frp-wvN3zFT0X0"
        options.clientID = "965585821604-3sge2e3qkercm96magfkepdvv7aakr17.apps.googleusercontent.com"
        FirebaseApp.configure(options: options)
    }
    
    private func setupFirebase() {
        FirebaseApp.configure()
        registerForPushNotifications()
    }
    
    private func registerForPushNotifications() {
        let manager = assembler.resolver.resolve(PushNotificationManager.self)
        manager?.register()
    }
}

private enum Constants {
    static let titleTextAttributes: [NSAttributedString.Key: Any] = [
        :
    ]
    static let textViewAttributes: [NSAttributedString.Key: Any] = [
        :
    ]
}

