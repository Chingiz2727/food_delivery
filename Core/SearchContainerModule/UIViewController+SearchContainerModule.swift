import UIKit

public extension UIViewController {

  typealias SearchTapCompletion = () -> Void

  private enum AssociatedKeys {
    static var searchActionKey = "search_action_key"
  }

  private var searchPressed: SearchTapCompletion! {
    get {
      return objc_getAssociatedObject(self, &AssociatedKeys.searchActionKey) as? SearchTapCompletion
    }
    set {
      objc_setAssociatedObject(self, &AssociatedKeys.searchActionKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
    }
  }

  func addSearchToNavigationBar(action: @escaping SearchTapCompletion) {
    let searchButton = UIBarButtonItem(
      image: Images.search.image,
      style: .plain,
      target: self,
      action: #selector(pressed(sender:))
    )
    addToRight(barButton: searchButton)
    self.searchPressed = action
  }

  @objc private func pressed(sender: UIBarButtonItem) {
    searchPressed()
  }
}
