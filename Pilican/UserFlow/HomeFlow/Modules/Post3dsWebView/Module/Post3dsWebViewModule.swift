protocol Post3dsWebViewModule: Presentable {
    typealias OnCardAddTryed = (Status) -> Void
    var onCardAddTryed: OnCardAddTryed? { get set }
}
