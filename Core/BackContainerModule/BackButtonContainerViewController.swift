import UIKit

final class BackButtonContainerViewController: UIViewController, ViewHolder {

  typealias RootViewType = BackButtonContainerView

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
    view = BackButtonContainerView(rootView: rootViewController.view)
    rootViewController.didMove(toParent: self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    rootView.backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)
  }

  @objc private func backPressed() {
    if let backPressHandler = rootViewController as? BackPressHandler {
      backPressHandler.handleBackPress()
      return
    }

    guard let navigationController = navigationController else {
      dismiss(animated: true)
      return
    }

    navigationController.popViewController(animated: true)
  }
}

