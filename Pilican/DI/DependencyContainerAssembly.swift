import Swinject
import CoreLocation
import AVFoundation
typealias DependencyContainer = Resolver

public final class DependencyContainerAssembly: Assembly {
    // swiftlint:disable function_body_length
    public func assemble(container: Container) {
        container.register(AppLanguage.self) { _ in
            AppLanguage.default
        }.inObjectScope(.container)
        ApiServicesAssemblyImpl()
            .registerNetworkLayer(in: container)
        AuthServiceAssemblyImpl()
            .registerAuthService(in: container)
        container.register(ConfigService.self) { _ in
            ConfigServiceImpl()
        }.inObjectScope(.container)
        container.register(AppSessionManager.self) { resolver in
            AppSessionManager(notificationCenter: resolver.resolve(NotificationCenter.self)!)
        }.inObjectScope(.container)
        container.register(CLLocationManager.self) { _ in
            CLLocationManager()
        }.inObjectScope(.transient)
        container.register(NotificationCenter.self) { _ in
            NotificationCenter.default
        }.inObjectScope(.container)
        
        container.register(UIApplication.self) { _ in
            UIApplication.shared
        }.inObjectScope(.container)
        container.register(MapManager.self, factory: { _ in
            MapManager(engine: YandexMapViewModel())
        }).inObjectScope(.container)
        container.register(UserInfoStorage.self) { _ in
            UserInfoStorage()
        }.inObjectScope(.container)
        container.register(BiometricAuthService.self) { _ in
            BiometricAuthService()
        }.inObjectScope(.container)
        container.register(UserSessionStorage.self) { _ in
            UserSessionStorage()
        }.inObjectScope(.container)
        // CameraUsage DI
        container.register(AVAuthorizationStatus.self) { _ in
            AVCaptureDevice.authorizationStatus(for: .video)
        }
        container
            .register(UNUserNotificationCenter.self) { _ in
                UNUserNotificationCenter.current()
            }
            .inObjectScope(.container)
        container.register(PushNotificationManager.self) { resolver in
            PushNotificationManager(engine: FirebasePushNotificationEngine(
                                        appSession: resolver.resolve(AppSessionManager.self)!,
                                        userNotificationCenter: resolver.resolve(UNUserNotificationCenter.self)!,
                                        application: resolver.resolve(UIApplication.self)!,
                                        deepLinkActionFactory: resolver.resolve(DeepLinkActionFactory.self)!)
            )
        }.inObjectScope(.container)
        container.register(CameraUsagePermission.self) {  _ in
            let status = container.resolve(AVAuthorizationStatus.self)!
            return CameraUsagePermission(avAuthorizationStatus: status)
        }
        container.register(DeliveryLocationModule.self) { _ in
            let viewModel = DeliveryLocationMapViewModel(mapManager: container.resolve(MapManager.self)!, userInfoStorage: container.resolve(UserInfoStorage.self)!)
            return DeliveryLocationViewController(viewModel: viewModel, mapManager: container.resolve(MapManager.self)!)
        }.inObjectScope(.container)
        
        container.register(AVMediaType.self) { _ in
            AVMediaType.video
        }

        container.register(AVCaptureDevice.self) { _ in
            let mediaType = container.resolve(AVMediaType.self)!
            return AVCaptureDevice.default(for: mediaType)!
        }

        container.register(AVCaptureSession.self) { _ in
            return AVCaptureSession()
        }
        container.register(WorkCalendar.self) { _ in
            return WorkCalendar(
                dateFormatter: container.resolve(PropertyFormatter.self)!,
                calendar: container.resolve(Calendar.self)!
            )
        }
        container.register(Calendar.self) { _ in
            Calendar.current
        }
        container.register(FavouritesManager.self) { _ in
            return FavouritesManager(apiService: container.resolve(ApiService.self)!, userInfoStorage: container.resolve(UserInfoStorage.self)!)
        }
        container.register(UserInfoUpdater.self) { _ in
            return UserInfoUpdaterImpl(
                apiService: container.resolve(ApiService.self)!,
                userSession: container.resolve(UserSessionStorage.self)!,
                appSession: container.resolve(AppSessionManager.self)!,
                userInfo: container.resolve(UserInfoStorage.self)!)
        }
        container.register(AVCaptureVideoPreviewLayer.self) {  _ in
            let session = container.resolve(AVCaptureSession.self)!
            let layer = AVCaptureVideoPreviewLayer(session: session)
            return layer
        }
        container.register(AuthStateObserver.self) { _ in
            AuthStateObserver(userSession: container.resolve(UserInfoStorage.self)!, appSession: container.resolve(UserSessionStorage.self)!)
        }.inObjectScope(.container)

        container.register(DeliveryLogoutStateObserver.self) { _ in
            DeliveryLogoutStateObserver()
        }.inObjectScope(.container)
        container.register(PropertyFormatter.self) { resolver in
            PropertyFormatter(appLanguage: resolver.resolve(AppLanguage.self)!)
        }.inObjectScope(.container)

        container.register(DishList.self) { resolver in
            DishList()
        }.inObjectScope(.container)

        container.register(CameraModule.self) { _ in
            let session = container.resolve(AVCaptureSession.self)!
            let device = container.resolve(AVCaptureDevice.self)!
            let layer = container.resolve(AVCaptureVideoPreviewLayer.self)!
            let cameraUsagePermission = container.resolve(CameraUsagePermission.self)!
            let userSession = container.resolve(UserSessionStorage.self)!
            let apiService = container.resolve(ApiService.self)!
            let viewModel = CameraViewModel(apiService: apiService)
            let controller = CameraViewController(
                avCaptureSession: session,
                avCaptureDevice: device,
                avCapturePreviewLayer: layer,
                cameraUsagePermession: cameraUsagePermission,
                userSession: userSession,
                viewModel: viewModel)
            return controller
        }
        container.register(DeepLinkActionFactory.self) { _ in
            DeepLinkActionFactory()
        }.inObjectScope(.container)
    }
}
