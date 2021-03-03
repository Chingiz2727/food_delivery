protocol HomeModule: Presentable {
    typealias SelectRetail = (Retail) -> Void

    var selectRetail: SelectRetail? { get set }
}
