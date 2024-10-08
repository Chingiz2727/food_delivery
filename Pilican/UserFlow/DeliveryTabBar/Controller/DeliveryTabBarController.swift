import RxSwift
import UIKit

enum DeliveryTabBarItem: Int {
    case delivery
    case search
    case basket
    case map
    case home
}

protocol DeliveryTabBarItemCoordinator: BaseCoordinator {
    var onTabBarItemNeedsToBeChanged: ((_ toTabBarItem: DeliveryTabBarItem) -> Void)? { get set }
}

protocol DeliveryTabBarPresentable {
    typealias SelectRetail = (Int?) -> Void
    var selectRetail: SelectRetail? { get set }
    func setViewControllers(_ viewControllers: [UIViewController])
    func changeSelectedTabBarItem(_ tabBarItem: DeliveryTabBarItem, completion: Callback?)
}

final class DeliveryTabBarController: UITabBarController, DeliveryTabBarPresentable, UIGestureRecognizerDelegate {
    private var overlayViews = [RetailCardView]()
    private let viewModel: DeliveryTabBarViewModel
    private let disposeBag = DisposeBag()
    var selectRetail: SelectRetail?
    let reloadSubject = BehaviorSubject<Void>.init(value: ())
    lazy var panGesture = UIPanGestureRecognizer()
    lazy var singleTap = UITapGestureRecognizer()
    var deliveryDetailsVCData = [[UIView: DeliveryOrderResponse?]]()
    let userRepo: UserInfoStorage
    init(viewModel: DeliveryTabBarViewModel) {
        self.viewModel = viewModel
        userRepo = assembler.resolver.resolve(UserInfoStorage.self)!
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("tab appeared")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name(NotificationsString.reloadRetailsBadge.rawValue), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(updateBadge), name: NSNotification.Name(NotificationsString.reloadRetailsBadge.rawValue), object: nil)
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(input: .init(viewDidLoad: reloadSubject))
        let activeOrder = output.activeOrders.publish()
        
        activeOrder.element.map { $0.orders }.subscribe(onNext: { [unowned self] myOrders in
            self.overlayViews.removeAll()
            self.deliveryDetailsVCData.removeAll()
            
            self.overlayViews = [RetailCardView]()
            deliveryDetailsVCData = [[UIView: DeliveryOrderResponse?]]()
            view.subviews.forEach { view in
                if view is RetailCardView {
                    view.removeFromSuperview()
                }
            }
            myOrders.forEach { response in
                let v = RetailCardView()
                let imgUrl = "https://st.pillikan.kz/retail/logo\(response.retailLogo ?? "")"
                v.setup(imgUrl: imgUrl)
                let dataFor = [v: response] as [UIView : DeliveryOrderResponse]
                self.deliveryDetailsVCData.append(dataFor)
                self.overlayViews.append(v)
            }
            self.setupOverlays(orderResponse: myOrders)
        })
        .disposed(by: disposeBag)
        
        activeOrder.connect()
            .disposed(by: disposeBag)
    }

    func setViewControllers(_ viewControllers: [UIViewController]) {
        self.viewControllers = viewControllers
    }
    
    @objc private func updateBadge() {
        reloadSubject.onNext(())
    }

    func changeSelectedTabBarItem(_ tabBarItem: DeliveryTabBarItem, completion: Callback?) {
        guard let viewController = viewControllers?[tabBarItem.rawValue] else { return }
        selectedViewController = viewController
        completion?()
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer == singleTap && otherGestureRecognizer == panGesture {
            return true
        }
        return false
    }

    var appFullscreenBeginOffset: CGFloat = 0

    private func setupOverlays(orderResponse: [DeliveryOrderResponse]) {
        for v in overlayViews {
            view.addSubview(v)
            v.frame = .init(x: 10,
                            y: 100,
                            width: 70,
                            height: 70)

            v.layer.borderWidth = 0.5
            v.layer.borderColor = UIColor.primary.cgColor

            v.layer.cornerRadius = 10.2
            v.isUserInteractionEnabled = true

            panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
            panGesture.minimumNumberOfTouches = 1
            panGesture.delegate = self
            v.addGestureRecognizer(panGesture)

            singleTap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
            singleTap.delegate = self
            v.addGestureRecognizer(singleTap)
        }
    }

    @objc fileprivate func handleTap(_ gesture: UITapGestureRecognizer) {
        if let firstHitView = overlayViews.first(where: { $0.bounds.contains(gesture.location(in: $0)) }) {
            deliveryDetailsVCData.forEach { (dictionary) in
                if let dataFor = dictionary[firstHitView] {
                    self.selectRetail?(dataFor?.id)
                }
            }
        }
    }

    @objc fileprivate func handlePan(_ gesture: UIPanGestureRecognizer) {

        if let firstHitView = overlayViews.first(where: { $0.bounds.contains(gesture.location(in: $0)) }) {
            if navigationController?.presentedViewController == firstHitView {
                return
            }
        }

        let translation = gesture.translation(in: view)

        guard let gestureView = gesture.view else {
            return
        }

        gestureView.center = CGPoint(
            x: gestureView.center.x + translation.x,
            y: gestureView.center.y + translation.y
        )

        gesture.setTranslation(.zero, in: view)

        guard gesture.state == .ended else {
            return
        }

        let velocity = gesture.velocity(in: view)
        let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
        let slideMultiplier = magnitude / 200

        let slideFactor = 0.1 * slideMultiplier

        var finalPoint = CGPoint(
            x: gestureView.center.x + (velocity.x * slideFactor),
            y: gestureView.center.y + (velocity.y * slideFactor)
        )

        finalPoint.x = min(max(finalPoint.x + 80, 80), view.bounds.width - 80)
        finalPoint.y = min(max(finalPoint.y + 150, 150), view.bounds.height - 150)

        UIView.animate(
            withDuration: Double(slideFactor * 0.8),
            delay: 0,

            options: .curveEaseOut,
            animations: {
                gestureView.center = finalPoint
            })
    }
}
