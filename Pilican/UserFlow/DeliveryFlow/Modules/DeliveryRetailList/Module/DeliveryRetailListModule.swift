protocol DeliveryRetailListModule: Presentable {
    typealias OnRetailDidSelect = (DeliveryRetail) -> Void
    typealias DeliveryMenuDidSelect = () -> Void
    var onRetailDidSelect: OnRetailDidSelect? { get set }
    var deliveryMenuDidSelect: DeliveryMenuDidSelect? { get set }
}
