protocol RegisterModule: Presentable {
    typealias QrScanTapped = () -> Void
    typealias RegisterTapped = () -> Void
    typealias PutPromoCodeToText = (String) -> Void

    var putPromoCodeToText: PutPromoCodeToText? { get set }
    var qrScanTapped: QrScanTapped? { get set }
    var registerTapped: RegisterTapped? { get set }
}
