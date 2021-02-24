protocol AuthBySmsModule: Presentable {
    typealias RegisterButtonTapped = () -> Void
    var onAuthDidFinish: Callback? { get set }
    var registerButtonTapped: RegisterButtonTapped? { get set }
}
