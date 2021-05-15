protocol HomeModule: Presentable {
    typealias SelectRetail = (Retail) -> Void
    typealias SelectMenu = (HomeCategoryMenu) -> Void

    var selectMenu: SelectMenu? { get set }
    var selectRetail: SelectRetail? { get set }
    var showMyQr: Callback? { get set }
}
