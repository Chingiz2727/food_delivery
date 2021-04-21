protocol DeliveryLocationModule: Presentable {
    typealias OnLocationDidSelect = (DeliveryLocation) -> Void
    
    var onlocationDidSelect: OnLocationDidSelect? { get set }
}
