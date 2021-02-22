import UIKit

public protocol Coordinator: class {
    func start()
    func start(with action: DeepLinkAction?)
    func performDeepLinkActionAfterStart(_ action: DeepLinkAction)
}

public extension Coordinator {
    func start(with action: DeepLinkAction?) {}
    func performDeepLinkActionAfterStart(_ action: DeepLinkAction) {}
}
