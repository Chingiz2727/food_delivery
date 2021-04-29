protocol RetailDetailModule: Presentable {
    var presentProblem: Callback? { get set }
    typealias RetailDetailTapped = (RetailDetail) -> Void
    var retailDetailTapped: RetailDetailTapped? { get set }
}
