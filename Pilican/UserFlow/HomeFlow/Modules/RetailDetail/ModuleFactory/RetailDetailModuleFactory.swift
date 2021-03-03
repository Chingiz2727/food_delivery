final class RetailDetailModuleFactory {
    private let container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
    }
    
    func makeRetailDetail(retail: Retail, workCalendar: WorkCalendar) -> RetailDetailModule {
        return RetailDetailViewController(retail: retail, workCalendar: workCalendar)
    }
}
