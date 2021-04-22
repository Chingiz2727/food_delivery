protocol ItemSearchModule: Presentable {
    typealias OnDeliveryCompanyDidSelect = (DeliveryRetail) -> Void
    var onDeliveryRetailCompanyDidSelect: OnDeliveryCompanyDidSelect? { get set }
}
