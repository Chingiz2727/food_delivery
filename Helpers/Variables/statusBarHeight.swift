import UIKit

/// Возвращает высоту до верхней границы navigationBar-a (statusBarHeight + safeAreaInsets). Функции объявлена `internal` в явном виде, чтобы подчеркнуть что её лучше использовать в конкретном контексте `KTUIKit`, нежели чем в основном приложении.
public func getStatusBarHeight() -> CGFloat {
    var statusBarHeight: CGFloat = 0
    if #available(iOS 13.0, *) {
        let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first
        statusBarHeight = window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
    } else {
        statusBarHeight = UIApplication.shared.statusBarFrame.height
    }
    return statusBarHeight
}
