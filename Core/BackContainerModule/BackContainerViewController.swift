import UIKit

final class BackContainerViewController: UIViewController, ViewHolder {

  typealias RootViewType = BackContainerView

  private let rootViewController: UIViewController
  private let trailingViewInTitleController: UIViewController?

  init(rootViewController: UIViewController, trailingViewInTitleController: UIViewController?) {
    self.rootViewController = rootViewController
    self.trailingViewInTitleController = trailingViewInTitleController
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func loadView() {
    addChild(rootViewController)
    trailingViewInTitleController.map { addChild($0) }
    view = BackContainerView(rootView: rootViewController.view, trailingTitleView: trailingViewInTitleController?.view)
    rootViewController.didMove(toParent: self)
    trailingViewInTitleController.map { $0.didMove(toParent: self) }
  }

  var titleObserver: Any?

  override func viewDidLoad() {
    super.viewDidLoad()

    rootView.backButton.addTarget(self, action: #selector(backPressed), for: .touchUpInside)

    titleObserver = rootViewController.observe(\.title, options: [.initial, .new]) { [weak self] _, rootTitle  in
      self?.rootView.set(title: rootTitle.newValue ?? "")
    }
  }

  @objc private func backPressed() {
    if let backPressHandler = rootViewController as? BackPressHandler {
      backPressHandler.handleBackPress()
    } else {
      dismiss(animated: true)
    }
  }
}
