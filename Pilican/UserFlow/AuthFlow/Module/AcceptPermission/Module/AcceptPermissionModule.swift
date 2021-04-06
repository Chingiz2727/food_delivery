import Foundation

protocol AcceptPermissionModule: Presentable {
    typealias NextTapped = () -> Void
    var nextTapped: NextTapped? { get set }
    var isHidden: Bool? { get set }
}
