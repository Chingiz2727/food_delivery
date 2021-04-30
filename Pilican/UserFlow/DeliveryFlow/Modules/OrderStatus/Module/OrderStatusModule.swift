protocol OrderStatusModule: Presentable {
    typealias OrderSend = (DeliveryOrderResponse) -> Void
    var orderSend: OrderSend? { get set }
}
