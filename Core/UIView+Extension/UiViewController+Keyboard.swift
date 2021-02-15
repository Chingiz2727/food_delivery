import UIKit
import RxSwift

public extension UIViewController {

  static var bottomInset: CGFloat {
    return UIApplication.shared.keyWindow?.safeAreaInsets.bottom ?? 0.0
  }

  struct Keyboard {
    public static func animationTime(_ notification: Notification) -> Double {
      let animationTime = notification.userInfo?[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double
      return animationTime ?? 0.3
    }

    public static func height(_ notification: Notification) -> CGFloat {
      let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
      return keyboardSize?.height ?? 300.0
    }
  }
}
