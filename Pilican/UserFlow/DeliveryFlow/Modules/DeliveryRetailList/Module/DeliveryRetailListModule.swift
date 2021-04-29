protocol DeliveryRetailListModule: Presentable {
    typealias OnRetailDidSelect = (DeliveryRetail) -> Void
    typealias OnSelectStatus = (DeliveryOrderResponse) -> Void
    typealias DeliveryMenuDidSelect = () -> Void
    
    var onSelectToStatus: OnSelectStatus? { get set }
    var onRetailDidSelect: OnRetailDidSelect? { get set }
    var deliveryMenuDidSelect: DeliveryMenuDidSelect? { get set }
}
