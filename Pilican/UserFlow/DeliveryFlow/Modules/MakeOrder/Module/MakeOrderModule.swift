protocol MakeOrderModule: Presentable {
    var onMapShowDidSelect: Callback? { get set }
    typealias EmptyDishList = () -> Void
    typealias OrderSuccess = (OrderResponse) -> Void
    typealias OrderError = () -> Void
    typealias PutAddress = (DeliveryLocation) -> Void
    var putAddress: PutAddress? { get set }
    var orderSuccess: OrderSuccess? { get set }
    var emptyDishList: EmptyDishList? { get set }
    var orderError: OrderError? { get set }
}
