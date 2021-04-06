import UIKit
import Swinject
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    let assembler = Assembler([DependencyContainerAssembly()])
    private var appCoordinator: AppCoordinator?

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        setupWindow()
        makeCoordinator(application: application)
        setupKeyboardManager()
        setupNavigationBar()
        LoggerConfigurator.configure()
        // Override point for customization after application launch.
        return true
    }

    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = CoordinatorNavigationController(
            backBarButtonImage: Images.close.image?.withRenderingMode(.alwaysOriginal),
            closeBarButtonImage: Images.close.image?.withRenderingMode(.alwaysOriginal)
        )
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

    private func setupNavigationBar() {
        let navigationBar = UINavigationBar.appearance()
        navigationBar.isTranslucent = false
        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.titleTextAttributes = Constants.titleTextAttributes
        navigationBar.tintColor = .pilicanBlack
        navigationBar.barTintColor = .background
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
