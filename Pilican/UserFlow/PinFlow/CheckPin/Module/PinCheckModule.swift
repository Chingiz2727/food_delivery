protocol PinCheckModule: Presentable {
    typealias OnPinSatisfy = () -> Void
    
    var onPinSatisfy: OnPinSatisfy? { get set }
    var onResetTapp: Callback? { get set }
}
