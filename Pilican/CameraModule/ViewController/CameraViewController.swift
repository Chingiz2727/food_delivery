import RxSwift
import AVFoundation
import UIKit

class CameraViewController: UIViewController, CameraModule {

    var promoCodeScanned: PromoCodeScanned?
    var paymentMaked: PaymentMaked?
    var cameraActionType: CameraAction?

    private var avCaptureOuput: AVCaptureOutput?
    private let avCaptureSession: AVCaptureSession
    private var avCaptureDevice: AVCaptureDevice
    private let avCapturePreviewLayer: AVCaptureVideoPreviewLayer
    private var avCaptureMetadaDegelegate: CameraMetadaOutputDelegate?
    private let cameraUsagePermission: CameraUsagePermission
    private let disposeBag = DisposeBag()
    private let cameraView = CameraView()

    init(
        avCaptureSession: AVCaptureSession,
        avCaptureDevice: AVCaptureDevice,
        avCapturePreviewLayer: AVCaptureVideoPreviewLayer,
        cameraUsagePermession: CameraUsagePermission
    ) {
        self.avCaptureSession = avCaptureSession
        self.avCaptureDevice = avCaptureDevice
        self.avCapturePreviewLayer = avCapturePreviewLayer
        self.cameraUsagePermission = cameraUsagePermession
        avCaptureMetadaDegelegate = CameraMetadaOutputDelegate()
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        navigationController?.navigationBar.isHidden = true
    }

    private func bindViewModel() {
        cameraUsagePermission.checkStatus()
        cameraUsagePermission.isAccesGranted
            .subscribe(onNext: { [unowned self] isEnabled in
                if isEnabled {
                    self.setupCamera()
                }
            }).disposed(by: disposeBag)

        cameraView.rotateCameraButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.rotateCamera()
            })
            .disposed(by: disposeBag)

        cameraView.flashLightButton.rx.tap
            .subscribe(onNext: { [unowned self] _ in
                self.setFlash()
            }).disposed(by: disposeBag)

        avCaptureMetadaDegelegate?.qrScanned = { [unowned self] qr in
            self.avCaptureSession.stopRunning()
            if qr.isStringContainsOnlyNumbers() {
                // create Order
            } else {
                self.promoCodeScanned?(qr)
            }
        }
    }

    private func setupCamera() {
        addCameraSession()
        addCameraOutput()
        addPreviewLayer()
    }

    private func addCameraSession() {
        guard let input = try? AVCaptureDeviceInput(device: avCaptureDevice) else { return }
        avCaptureSession.addInput(input)
    }

    private func addCameraOutput() {
        let output = AVCaptureMetadataOutput()
        avCaptureSession.addOutput(output)
        output.setMetadataObjectsDelegate(avCaptureMetadaDegelegate, queue: DispatchQueue.main)
        output.metadataObjectTypes = [AVMetadataObject.ObjectType.qr]
        avCaptureSession.startRunning()
    }

    private func addPreviewLayer() {
        avCapturePreviewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        avCapturePreviewLayer.frame = view.bounds
        view.layer.addSublayer(avCapturePreviewLayer)
        cameraView.frame = view.frame
        view.addSubview(cameraView)
    }

    private func rotateCamera() {
        if avCaptureDevice.position == .back {
            avCaptureDevice = AVCaptureDevice.DiscoverySession(
                deviceTypes: [.builtInWideAngleCamera],
                mediaType: AVMediaType.video, position: .front
            ).devices.first ?? avCaptureDevice
        } else {
            avCaptureDevice = AVCaptureDevice.DiscoverySession(
                deviceTypes: [.builtInWideAngleCamera],
                mediaType: AVMediaType.video, position: .back
            ).devices.first ?? avCaptureDevice
        }
        if isInputRemovable() {
            addCameraSession()
        }
    }

    private func isInputRemovable() -> Bool {
        guard let input = avCaptureSession.inputs.first else { return false }
        avCaptureSession.removeInput(input)
        return true
    }

    private func setFlash() {
        guard avCaptureDevice.hasTorch else { return }
        do {
            try avCaptureDevice.lockForConfiguration()
            if avCaptureDevice.torchMode == AVCaptureDevice.TorchMode.on {
                avCaptureDevice.torchMode = AVCaptureDevice.TorchMode.off
            } else {
                do {
                    try avCaptureDevice.setTorchModeOn(level: 1)
                } catch let error { print(error) }
            }
            avCaptureDevice.unlockForConfiguration()
        } catch let error {
            print(error)
        }
    }
}
