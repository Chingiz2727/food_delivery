import UIKit
import IQKeyboardManagerSwift

final class CardContainerViewController: UIViewController, ViewHolder {

  typealias RootViewType = CardContainerView

  private var initialOrigin: CGPoint = .zero

  private let rootViewController: UIViewController

  init(rootViewController: UIViewController) {
    self.rootViewController = rootViewController
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    addChild(rootViewController)
    view = CardContainerView(rootView: rootViewController.view)
    rootViewController.didMove(toParent: self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    addKeyboardNotifications()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    IQKeyboardManager.shared.enable = false
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    initialOrigin = view.frame.origin
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    IQKeyboardManager.shared.enable = true
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    preferredContentSize = view.systemLayoutSizeFitting(
      CGSize(width: view.frame.width, height: UIView.layoutFittingCompressedSize.height)
    )
  }

  private func addKeyboardNotifications() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.keyboardWillShow(notification:)),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(self.keyboardWillHide(notification:)),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }

  @objc private func keyboardWillShow(notification: Notification) {

    //Add asyncAfter to fix bug when views origin doesn't change when shake device
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
      UIView.animate(withDuration: UIViewController.Keyboard.animationTime(notification)) {
        self.view.frame.origin.y = self.initialOrigin.y
          - (UIViewController.Keyboard.height(notification)
            - UIViewController.bottomInset)
        self.view.layoutIfNeeded()
      }
    }
  }

  @objc private func keyboardWillHide(notification: Notification) {
    UIView.animate(withDuration: UIViewController.Keyboard.animationTime(notification)) {
      self.view.frame.origin.y = self.initialOrigin.y
      self.view.layoutIfNeeded()
    }
  }
}

extension CardContainerViewController: DismissActionable {
  func actionAfterDismiss() {
    (rootViewController as? DismissActionable)?.actionAfterDismiss()
  }
}
