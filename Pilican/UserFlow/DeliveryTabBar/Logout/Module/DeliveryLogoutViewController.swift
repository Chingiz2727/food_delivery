import UIKit

final class DeliveryLogoutViewController: UIViewController, DeliveryLogoutModule {

    private let deliveryLogout: DeliveryLogoutStateObserver
    
    init(deliveryLogout: DeliveryLogoutStateObserver) {
        self.deliveryLogout = deliveryLogout
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        deliveryLogout.forceLogout()
    }

}
