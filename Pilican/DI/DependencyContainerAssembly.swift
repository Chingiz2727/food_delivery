import Swinject
import AVFoundation

public typealias DependencyContainer = Resolver

public final class DependencyContainerAssembly: Assembly {
    public func assemble(container: Container) {
        ApiServicesAssemblyImpl()
            .registerNetworkLayer(in: container)
        AuthServiceAssemblyImpl()
            .registerAuthService(in: container)
        container.register(ConfigService.self) { _ in
            ConfigServiceImpl()
        }.inObjectScope(.container)
        container.register(NotificationCenter.self) { _ in
            NotificationCenter.default
        }.inObjectScope(.container)
        // CameraUsage DI
        container.register(AVAuthorizationStatus.self) { _ in
            AVCaptureDevice.authorizationStatus(for: .video)
        }

        container.register(CameraUsagePermission.self) {  _ in
            let status = container.resolve(AVAuthorizationStatus.self)!
            return CameraUsagePermission(avAuthorizationStatus: status)
        }

        container.register(AVMediaType.self) { _ in
            AVMediaType.video
        }

        container.register(AVCaptureDevice.self) { _ in
            let mediaType = container.resolve(AVMediaType.self)!
            return AVCaptureDevice.default(for: mediaType)!
        }

        container.register(AVCaptureMetadataOutput.self) { _ in
            let output = AVCaptureMetadataOutput()
            output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
            return output
        }

        container.register(AVCaptureSession.self) { _ in
            return AVCaptureSession()
        }

        container.register(AVCaptureVideoPreviewLayer.self) {  _ in
            let session = container.resolve(AVCaptureSession.self)!
            let layer = AVCaptureVideoPreviewLayer(session: session)
            return layer
        }

        container.register(CameraModule.self) { _ in
            let session = container.resolve(AVCaptureSession.self)!
            let device = container.resolve(AVCaptureDevice.self)!
            let layer = container.resolve(AVCaptureVideoPreviewLayer.self)!
            let output = container.resolve(AVCaptureMetadataOutput.self)!
            let controller = CameraViewController(
                avCaptureSession: session,
                avCaptureDevice: device,
                avCapturePreviewLayer: layer,
                avCaptureOuput: output)
            return controller
        }
    }
}
