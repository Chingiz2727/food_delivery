protocol DeliveryRetailListModule: Presentable {
    typealias OnRetailDidSelect = (DeliveryRetail) -> Void

    var onRetailDidSelect: OnRetailDidSelect? { get set }
}
