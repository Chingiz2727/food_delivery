import UIKit
import Swinject

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
        LoggerConfigurator.configure()
        // Override point for customization after application launch.
        return true
    }

    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
    }

    func makeCoordinator(application: UIApplication) {
        let rootContainer = Container()
        rootContainer.register(AppRouter.self) { [unowned self] _ in
            return AppRouterImpl(window: self.window)
        }

        let rootAssembler = Assembler(
            [
                DependencyContainerAssembly()
            ],
            container: rootContainer)

        let coordinator = AppCoordinator(router: AppRouterImpl(window: window), container: rootAssembler.resolver)
        coordinator.start()
    }
}
