final class RetailDetailModuleFactory {
    private let container: DependencyContainer

    init(container: DependencyContainer) {
        self.container = container
    }
    
    func makeRetailDetail(retail: Retail, workCalendar: WorkCalendar) -> RetailDetailModule {
        return RetailDetailViewController(retail: retail, workCalendar: workCalendar)
    }
    
    func makeProblemVC(retail: Retail) -> ProblemModule {
        let apiService = container.resolve(ApiService.self)!
        let viewModel = ProblemViewModel(apiService: apiService, retailId: retail.id)
        let viewController = ProblemViewController(viewModel: viewModel)
        return viewController
    }
}
