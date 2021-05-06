protocol CreatePinModule: Presentable {
    var onCodeValidate: Callback? { get set }
    typealias CloseButton = () -> Void
    var closeButton: CloseButton? { get set }
}
