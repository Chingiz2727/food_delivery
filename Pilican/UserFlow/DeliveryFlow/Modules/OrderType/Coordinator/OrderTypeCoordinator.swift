//
//  OrderTypeCoordinator.swift
//  Pilican
//
//  Created by kairzhan on 4/7/21.
//
import CoreLocation
import Foundation

final class OrderTypeCoordinator: BaseCoordinator, DeliveryTabBarItemCoordinator {
    var onTabBarItemNeedsToBeChanged: ((DeliveryTabBarItem) -> Void)?
    
    private let moduleFactory: OrderTypeCoordinatorModuleFactory
    
    override init(router: Router, container: DependencyContainer) {
        moduleFactory = OrderTypeCoordinatorModuleFactory(container: container, router: router)
        super.init(router: router, container: container)
    }
    
    override func start() {
        showBasket()
    }
    
    private func showBasket() {
        var module = moduleFactory.makeBasket()
        module.onDeliveryChoose = { [weak self] orderType, userLocation in
            self?.showMakeOrder(orderType: orderType, userLocation: userLocation)
        }
        router.setRootModule(module, isNavigationBarHidden: false)
    }
    
    private func showMakeOrder(orderType: OrderType, userLocation: CLLocationCoordinate2D) {
        var module = moduleFactory.makeMakeOrder(orderType: orderType, userLocation: userLocation)
        module.onMapShowDidSelect = { [weak self] in
            self?.makeMapSearch()
        }
        module.emptyDishList = { [weak self] in
            self?.router.popModule()
        }
        router.push(module)
    }
    
    func makeMapSearch() {
        var module = container.resolve(DeliveryLocationModule.self)!
        module.onlocationDidSelect = { [weak self] location in
            print(location)
            self?.router.popModule()
        }
        router.push(module)
    }
}
