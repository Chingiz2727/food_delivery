final class MyCardsModuleFactory {
    
    private let container: DependencyContainer
    
    init(container: DependencyContainer) {
        self.container = container
    }
    
    func makeMyCards() -> MyCardsModule {
        let apiService = container.resolve(ApiService.self)!
        let myCardViewModel = MyCardsViewModel(apiService: apiService)
        return MyCardsViewController(viewModel: myCardViewModel)
    }
    
    func makeAddCard(cardName: String) -> AddCardModule {
        let apiService = container.resolve(ApiService.self)!
        let cardService = AddCardApiServiceImpl(apiService: apiService)
        let viewModel = AddCardViewModel(addCardApiService: cardService, sessionStorage: container.resolve(UserSessionStorage.self)!, cardName: cardName)
        let controller = AddCardViewController(viewModel: viewModel)
        return controller
    }
    
    func make3dsWeb(cardModel: BindCardModel, htmlString: String) -> Post3dsWebViewModule {
        let controller = Post3dsWebViewController(bindCardModel: cardModel, htmlString: htmlString, sessionStorage: container.resolve(UserSessionStorage.self)!)
        return controller
    }
    
    func showCardStatus(status: Status) -> AddCardStatusModule {
        let controller  = AddCardStatusViewController(status: status)
        return controller
    }
}
