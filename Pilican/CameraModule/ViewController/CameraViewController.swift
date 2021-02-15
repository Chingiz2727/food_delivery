import AVFoundation
import UIKit

class CameraViewController: UIViewController, CameraModule {
    var promoCodeScanned: PromoCodeScanned?
    var paymentMaked: PaymentMaked?
    var cameraActionType: CameraAction?

    private let avCaptureSession: AVCaptureSession
    private let avCaptureDevice: AVCaptureDevice
    private let avCapturePreviewLayer: AVCaptureVideoPreviewLayer
    private let avCaptureOuput: AVCaptureOutput

    init(
        avCaptureSession: AVCaptureSession,
        avCaptureDevice: AVCaptureDevice,
        avCapturePreviewLayer: AVCaptureVideoPreviewLayer,
        avCaptureOuput: AVCaptureOutput
    ) {
        self.avCaptureSession = avCaptureSession
        self.avCaptureDevice = avCaptureDevice
        self.avCapturePreviewLayer = avCapturePreviewLayer
        self.avCaptureOuput = avCaptureOuput
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
