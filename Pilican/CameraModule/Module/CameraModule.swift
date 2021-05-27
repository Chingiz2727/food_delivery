protocol CameraModule: Presentable {
    typealias PromoCodeScanned = (String) -> Void
    typealias PaymentMaked = (ScanRetailResponse, String?) -> Void
    typealias BusScanned = (ScanRetailResponse) -> Void
    typealias CloseButton = () -> Void
    typealias HowItWorkTapped = () -> Void
    typealias RetailTapped = (Retail) -> Void

    var cameraActionType: CameraAction? { get set }
    var promoCodeScanned: PromoCodeScanned? { get set }
    var paymentMaked: PaymentMaked? { get set }
    var busScanned: BusScanned? { get set }
    var closeButton: CloseButton? { get set }
    var howItWorkTapped: HowItWorkTapped? { get set }
    var retailTapped: RetailTapped? { get set }
    var retailIdTapped: RetailTapped? { get set }
}
