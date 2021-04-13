protocol RetailListMapModule: Presentable {
    typealias OnDeliveryRetailSelected = (DeliveryRetail) -> Void
    
    var onDeliveryRetailSelect: OnDeliveryRetailSelected? { get set }
}
