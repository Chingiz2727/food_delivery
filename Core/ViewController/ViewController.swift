import UIKit

open class ViewController: UIViewController, CoordinatorNavigationControllerDelegate {
    
    override open var prefersStatusBarHidden: Bool { false }

    override open func viewDidLoad() {
        super.viewDidLoad()
    }

    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setupCoordinatorNavigationController()
    }
    private func setupCoordinatorNavigationController() {
        guard let navigationController = navigationController as? CoordinatorNavigationController else { return }
        navigationController.coordinatorNavigationDelegate = self
    }

    open func transitionBackDidFinish() {}
    open func customBackButtonDidTap() {}
    open func customCloseButtonDidTap() {}

    open func updateLocalization() {}
    open func refreshRequests() {}
}
