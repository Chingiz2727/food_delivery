protocol RegisterModule: Presentable {
    typealias QrScanTapped = () -> Void
    typealias RegisterTapped = () -> Void

    var qrScanTapped: QrScanTapped? { get set }
    var registerTapped: RegisterTapped? { get set }
}
