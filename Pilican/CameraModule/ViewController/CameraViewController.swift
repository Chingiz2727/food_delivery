import RxSwift
import Vision
import AVFoundation
import UIKit

class CameraViewController: UIViewController, CameraModule {
    var retailIdTapped: RetailTapped?
    var howItWorkTapped: HowItWorkTapped?
    var closeButton: CloseButton?
    var busScanned: BusScanned?
    var promoCodeScanned: PromoCodeScanned?
    var paymentMaked: PaymentMaked?
    var cameraActionType: CameraAction?
    var retailTapped: RetailTapped?

    private var price: String?
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
    private let userSession: UserSessionStorage
    private let viewModel: CameraViewModel

    init(
        avCaptureSession: AVCaptureSession,
        avCaptureDevice: AVCaptureDevice,
        avCapturePreviewLayer: AVCaptureVideoPreviewLayer,
        cameraUsagePermession: CameraUsagePermission,
        userSession: UserSessionStorage,
        viewModel: CameraViewModel
    ) {
        self.avCaptureSession = avCaptureSession
        self.avCaptureDevice = avCaptureDevice
        self.avCapturePreviewLayer = avCapturePreviewLayer
        self.cameraUsagePermission = cameraUsagePermession
        self.userSession = userSession
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
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.isHidden = true
        navigationController?.navigationBar.isHidden = true
        tabBarController?.navigationController?.navigationBar.isHidden = true

    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        tabBarController?.navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
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
                let paymentQr = qr.components(separatedBy: "/")
                print(paymentQr)
                if paymentQr.count > 1 {
                    let id = paymentQr.first!.replacingOccurrences(of: " ", with: "")
                    let price = paymentQr.last!.replacingOccurrences(of: " ", with: "")
                    self.qrScanned(qr: id, price: price)
                } else {
                    self.qrScanned(qr: qr, price: nil)
                }
            case .bus:
                self.qrScanned(qr: qr, price: nil)
            default:
                break
            }
        }
    
        let adapter = viewModel.adapter
        adapter.connect(to: cameraView.tableView)
        adapter.start()

       let output = viewModel.transform(input: CameraViewModel.Input(
                                loadInfo: scanSubject,
                                createdAt: createdAtSubject,
                                sig: sigSubject,
                                retailId: retailIdSubject,
                                loadRetails: .just(()),
                                            retailIdentifier: cameraView.searchView.searchBar.rx.text.asObservable(),
                                            searchButtonTap: cameraView.searchView.searchButton.rx.tap.asObservable()))

        let retailList = output.retailList.publish()

        retailList.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)

        retailList.element
            .bind(to: cameraView.tableView.rx.items(CashBackListTableViewCell.self)) { _, model, cell in
                cell.setRetail(retail: model)
            }.disposed(by: disposeBag)

        retailList.connect()
            .disposed(by: disposeBag)

        cameraView.identificatorButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.cameraView.drawerView.isHidden = false
                self.cameraView.drawerView.setState(.middle, animated: true)
            }).disposed(by: disposeBag)

        let result = output.scanRetailResponse.publish()

        result.element
            .subscribe(onNext: { [unowned self] info in
                self.paymentMaked?(info,price)
            }).disposed(by: disposeBag)

        result.errors
            .subscribe(onNext: { [unowned self] error in
                self.showErrorInAlert(error) {
                    self.avCaptureSession.startRunning()
                }
            })
            .disposed(by: disposeBag)

        result.connect()
            .disposed(by: disposeBag)

        cameraView.howItWorkButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.howItWorkTapped?()
            }).disposed(by: disposeBag)

        cameraView.tableView.rx.itemSelected
            .withLatestFrom(retailList.element) { $1[$0.row] }
            .bind { [unowned self] retail in
                self.retailTapped?(retail)
            }.disposed(by: disposeBag)

        cameraView.searchView.searchButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.cameraView.drawerView.setState(.middle, animated: true)
                view.endEditing(true)
            }).disposed(by: disposeBag)

        self.cameraView.drawerView.isHidden = true
    }

    private func qrScanned(qr: String, price: String?) {
        self.price = price
        switch cameraActionType {
        case .makePayment:
            if let retailId = Int(qr) {
                createQrOrder(retailId: retailId)
            }
        case .bus:
            if let retailId = Int(qr) {
                createQrOrder(retailId: retailId)
            }
        default:
            break
        }
    }

    private func createQrOrder(retailId: Int) {
        let createdAt = String(NSDate().timeIntervalSince1970).split(separator: ".")[0]
        guard let token = userSession.accessToken else { return }
        let substring = ((token as NSString).substring(with: NSMakeRange(11, 21)) as NSString).substring(with:  NSMakeRange(0, 10))
        let sig = ((substring + String(createdAt) + String(retailId)).toBase64()).md5()
        createdAtSubject.onNext(String(createdAt))
        sigSubject.onNext(sig)
        retailIdSubject.onNext(retailId)
        scanSubject.onNext(())
    }

    private func setupCamera() {
        switch cameraActionType {
        case .readPromoCode:
            self.cameraView.drawerView.isHidden = true
        default:
            self.cameraView.drawerView.isHidden = false
        }
        
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
