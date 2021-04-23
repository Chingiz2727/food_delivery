import RxSwift
import Vision
import AVFoundation
import UIKit

class CameraViewController: UIViewController, CameraModule {
    var closeButton: CloseButton?
    var busScanned: BusScanned?
    var promoCodeScanned: PromoCodeScanned?
    var paymentMaked: PaymentMaked?
    var cameraActionType: CameraAction?

    private let scanSubject = PublishSubject<Void>()
    private let createdAtSubject = PublishSubject<String>()
    private let sigSubject = PublishSubject<String>()
    private let retailIdSubject = PublishSubject<Int>()
    private var avCaptureOuput: AVCaptureOutput?
    private let avCaptureSession: AVCaptureSession
    private var avCaptureDevice: AVCaptureDevice
    private let avCapturePreviewLayer: AVCaptureVideoPreviewLayer
    private var avCaptureMetadaDegelegate: CameraMetadaOutputDelegate?
    private let cameraUsagePermission: CameraUsagePermission
    private let disposeBag = DisposeBag()
    private let cameraView = CameraView()
    private var request: [VNRequest] = []
    private var authTokenService: AuthTokenService
    private let viewModel: CameraViewModel

    init(
        avCaptureSession: AVCaptureSession,
        avCaptureDevice: AVCaptureDevice,
        avCapturePreviewLayer: AVCaptureVideoPreviewLayer,
        cameraUsagePermession: CameraUsagePermission,
        authTokenService: AuthTokenService,
        viewModel: CameraViewModel
    ) {
        self.avCaptureSession = avCaptureSession
        self.avCaptureDevice = avCaptureDevice
        self.avCapturePreviewLayer = avCapturePreviewLayer
        self.cameraUsagePermission = cameraUsagePermession
        self.authTokenService = authTokenService
        self.viewModel = viewModel
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

        cameraView.closeButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.closeButton?()
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
            switch self.cameraActionType {
            case .readPromoCode:
                self.promoCodeScanned?(qr)
            case .makePayment:
                self.qrScanned(qr: qr)
            default:
                break
            }
        }

       let output = viewModel.transform(input: CameraViewModel.Input(
                                loadInfo: scanSubject,
                                createdAt: createdAtSubject,
                                sig: sigSubject,
                                retailId: retailIdSubject))

        let result = output.scanRetailResponse.publish()

        result.element
            .subscribe(onNext: { [unowned self] info in
                paymentMaked?(info)
            }).disposed(by: disposeBag)

        result.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)

        result.connect()
            .disposed(by: disposeBag)
    }

    private func qrScanned(qr: String) {
        switch cameraActionType {
        case .makePayment:
            if let retailId = Int(qr) {
                createQrOrder(retailId: retailId)
            }
        default:
            break
        }
    }

    private func createQrOrder(retailId: Int) {
        let createdAt = String(NSDate().timeIntervalSince1970).split(separator: ".")[0]
        guard let token = authTokenService.token?.accessToken else { return }
        let substring = ((token as NSString).substring(with: NSMakeRange(11, 21)) as NSString).substring(with:  NSMakeRange(0, 10))
        let sig = ((substring + String(createdAt) + String(retailId)).toBase64()).md5()
        createdAtSubject.onNext(String(createdAt))
        sigSubject.onNext(sig)
        retailIdSubject.onNext(retailId)
        scanSubject.onNext(())
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
