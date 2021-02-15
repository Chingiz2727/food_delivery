protocol CameraModule: Presentable {
    typealias PromoCodeScanned = (String) -> Void
    typealias PaymentMaked = () -> Void

    var cameraActionType: CameraAction? { get set }
    var promoCodeScanned: PromoCodeScanned? { get set }
    var paymentMaked: PaymentMaked? { get set }
}
