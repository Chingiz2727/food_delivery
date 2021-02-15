protocol AuthModule: Presentable {
    typealias AuthButtonTapped = () -> Void
    typealias AuthBySms = () -> Void
    typealias RegisterButtonTapped = () -> Void

    var authButtonTapped: AuthButtonTapped? { get set }
    var authBySms: AuthBySms? { get set }
    var registerButtonTapped: RegisterButtonTapped? { get set }
}
