protocol CameraModule: Presentable {
    typealias PromoCodeScanned = (String) -> Void
    typealias PaymentMaked = (ScanRetailResponse) -> Void
    typealias BusScanned = (String) -> Void

    var cameraActionType: CameraAction? { get set }
    var promoCodeScanned: PromoCodeScanned? { get set }
    var paymentMaked: PaymentMaked? { get set }
    var busScanned: BusScanned? { get set }
}
