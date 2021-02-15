import RxSwift
import AVFoundation

final class CameraUsagePermission {
    let isAccesGranted: BehaviorSubject<Bool> = .init(value: false)

    private let avAuthorizationStatus: AVAuthorizationStatus

    init(avAuthorizationStatus: AVAuthorizationStatus) {
        self.avAuthorizationStatus = avAuthorizationStatus
    }

    func checkStatus() {
        switch avAuthorizationStatus {
        case .authorized:
            isAccesGranted.onNext(true)
        case .notDetermined:
            requestCameraUsagePermission()
        default:
            isAccesGranted.onNext(false)
        }
    }

    private func requestCameraUsagePermission() {
        AVCaptureDevice.requestAccess(for: .video) { [unowned self] access in
            self.isAccesGranted.onNext(access)
        }
    }
}
