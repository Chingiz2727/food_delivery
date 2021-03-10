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
    }
    
    private func showDetail() {
        let workCalendar = WorkCalendar(
            dateFormatter: container.resolve(PropertyFormatter.self)!,
            calendar: container.resolve(Calendar.self)!
        )
        var module = moduleFactory.makeRetailDetail(retail: retail, workCalendar: workCalendar)
        module.presentProblem = { [weak self] in
            self?.presentProblemVC()
        }
        router.push(module)
    }

    private func presentProblemVC() {
        var module = moduleFactory.makeProblemVC(retail: retail)

        module.dissmissProblem = { [weak self] in
            self?.router.dismissModule()
        }

        router.presentActionSheet(module, interactive: true)
    }
}
