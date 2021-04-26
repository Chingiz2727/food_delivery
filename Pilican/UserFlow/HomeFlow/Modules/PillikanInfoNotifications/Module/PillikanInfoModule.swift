protocol PillikanInfoModule: Presentable {
    typealias CloseButton = () -> Void
    var closeButton: CloseButton? { get set }
}
