final class AccountModuleFactory {
    private let container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
    }
    
    func makeAccount() -> AccountModule {
        return AccountViewController()
    }
}
