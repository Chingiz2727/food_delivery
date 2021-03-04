protocol CashBackListModule: Presentable {
    typealias OnSelectRetail = (Retail) -> Void
    
    var onSelectRetail: OnSelectRetail? { get set }
}
