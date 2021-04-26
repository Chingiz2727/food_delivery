protocol PillikanPayModule: Presentable {
    typealias CloseButton = () -> Void
    var closeButton: CloseButton? { get set }
}
