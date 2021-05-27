import Foundation

protocol RetailDetailCoordinatorOutput: BaseCoordinator {
    var onFlowDidFinish: Callback? { get set }
}

final class RetailDetailCoordinator: BaseCoordinator, RetailDetailCoordinatorOutput {
    var onFlowDidFinish: Callback?

    private let moduleFactory: RetailDetailModuleFactory
    private let retail: Retail
    
    init(router: Router, container: DependencyContainer, retail: Retail) {
        moduleFactory = RetailDetailModuleFactory(container: container)
        self.retail = retail
        super.init(router: router, container: container)
    }

    override func start() {
        showDetail()
        onFlowDidFinish = { [weak self] in
            self?.router.popToRootModule()
        }
        removeDependency(self)
    }
    
    private func showDetail() {
        let workCalendar = WorkCalendar(
            dateFormatter: container.resolve(PropertyFormatter.self)!,
            calendar: container.resolve(Calendar.self)!
        )
        let dishList = container.resolve(DishList.self)!
        var module = moduleFactory.makeRetailDetail(retail: retail, workCalendar: workCalendar, dishList: dishList)
        module.presentProblem = { [weak self] in
            self?.presentProblemVC()
        }
        module.retailDetailTapped = { [unowned self] tap in
            switch tap {
            case .pay:
                self.showPaymentPartner(info: .init(orderId: 0, fullName: "", type: 1, retail: self.retail), price: nil)
            case .delivery:
                // swiftlint:disable line_length
                self.showDeliveryProduct(retail: .init(id: retail.id, cashBack: retail.cashBack, isWork: retail.isWork, longitude: retail.longitude, latitude: retail.latitude, dlvCashBack: retail.dlvCashBack, pillikanDelivery: retail.delivery, logo: retail.logo, address: retail.address, workDays: retail.workDays, payIsWork: retail.payIsWork, name: retail.name, status: retail.status, rating: retail.rating))
            case .map:
                self.showMap(retail: retail)
            }
        }
        router.push(module)
    }

    private func showPaymentPartner(info: ScanRetailResponse, price: String?) {
        let apiService = container.resolve(ApiService.self)!
        let userSessionStorage = container.resolve(UserSessionStorage.self)!
        let userInfo = container.resolve(UserInfoStorage.self)!
        let viewModel = QRPaymentViewModel(apiService: apiService, info: info, userSessionStorage: userSessionStorage)
        var module = moduleFactory.makePayPartner(viewModel: viewModel, userInfo: userInfo, price: price)
        module.openSuccessPayment = { [weak self] retail, price, cashback in
            self?.showSuccessPayment(retail: retail, price: price, cashback: cashback)
        }
        module.closeButton = { [weak self] in
            self?.router.popModule()
        }
        router.push(module)
    }

    private func showSuccessPayment(retail: Retail, price: Int, cashback: Int) {
        var module = moduleFactory.makeSuccessPayment(retail: retail, price: price, cashback: cashback)
        module.nextTapped = { [weak self] in
            self?.router.popToRootModule()
        }
        router.push(module)
    }

    private func showDeliveryProduct(retail: DeliveryRetail) {
        var module = moduleFactory.deliveryProduct(retail: retail)
        module.onMakeOrdedDidTap = { [weak self] in
            self?.showBasket()
        }
        module.alcohol = { [weak self] in
            self?.showAlcohol()
        }
        router.push(module)
    }

    private func showBasket() {
        var module = moduleFactory.makeBasket()
        module.onDeliveryChoose = { [weak self] orderType in
            self?.showMakeOrder(orderType: orderType)
        }
        router.push(module)
    }

    private func showMakeOrder(orderType: OrderType) {
        var module = moduleFactory.makeMakeOrder(orderType: orderType)
        module.onMapShowDidSelect = { [weak self] in
            self?.makeMapSearch(addressSelected: { address in
                module.putAddress?(address)
            })
        }
        module.emptyDishList = { [weak self] in
            self?.router.popModule()
        }
        module.orderSuccess = { [weak self] orderId in
            self?.showOrderSuccess(orderId: orderId)
        }
        module.orderError = { [weak self] in
            self?.showOrderError()
        }
        router.push(module)
    }

    private func showAlcohol() {
        var module = moduleFactory.makeAlcohol()
        module.acceptButtonTapped = { [weak self] in
            self?.router.dismissModule()
        }
        router.presentCard(module, isDraggable: true, isDismissOnDimEnabled: true, isCloseable: true)
    }

    private func showOrderError() {
        var module = moduleFactory.makeOrderError()
        module.repeatMakeOrder = { [weak self] in
            self?.router.popModule()
        }
        router.push(module)
    }

    private func showOrderSuccess(orderId: Int) {
        var module = moduleFactory.makeOrderSuccess(orderId: orderId)
        module.toMain = { [weak self] in
            self?.router.popToRootModule()
        }
        router.push(module)
    }

    func makeMapSearch(addressSelected: @escaping ((DeliveryLocation) -> Void)) {
        var module = container.resolve(DeliveryLocationModule.self)!
        module.onlocationDidSelect = { [weak self] location in
            self?.router.popModule()
            addressSelected(location)
        }
        router.push(module)
    }

    private func showMap(retail: Retail) {
        let module = moduleFactory.makeRetailMap(retail: retail)
        router.push(module)
    }

    private func presentProblemVC() {
        var module = moduleFactory.makeProblemVC(retail: retail)

        module.dissmissProblem = { [weak self] in
            self?.router.dismissModule()
        }
        router.presentCard(module)
    }
}
