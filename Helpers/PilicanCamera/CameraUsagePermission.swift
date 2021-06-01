import RxSwift
import AVFoundation

final class CameraUsagePermission {
    let isAccesGranted = PublishSubject<Bool>()

    let avAuthorizationStatus: AVAuthorizationStatus

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
            requestCameraUsagePermission()
//            isAccesGranted.onNext(false)
        }
    }

    private func requestCameraUsagePermission() {
        AVCaptureDevice.requestAccess(for: .video) { [unowned self] access in
            print(access)
            self.isAccesGranted.onNext(access)
        }
    }
}
