import UIKit

final class MyCardCoordinator: BaseCoordinator {
    private let moduleFactory: MyCardsModuleFactory
    
    override init(router: Router, container: DependencyContainer) {
        moduleFactory = MyCardsModuleFactory(container: container)
        super.init(router: router, container: container)
    }
    
    override func start() {
        showMyCards()
    }
    
    private func showMyCards() {
        var module = moduleFactory.makeMyCards()
        module.closeButton = { [weak self] in
            self?.router.popModule()
        }
        module.addCard = { [weak self] cardName in
            self?.showAddCard(cardName: cardName)
        }
        router.push(module)
    }
    
    private func showAddCard(cardName: String) {
        var module = moduleFactory.makeAddCard(cardName: cardName)
        module.sendToWebController = { [weak self] model, html in
            self?.show3dsWebView(cardModel: model, htmlString: html)
        }
        
        module.showCardStatus = { [weak self] status in
            self?.showCardStatus(status: status)
        }
        
        router.push(module)
    }
    
    private func show3dsWebView(cardModel: BindCardModel, htmlString: String) {
        var module = moduleFactory.make3dsWeb(cardModel: cardModel, htmlString: htmlString)
        module.onCardAddTryed = { [weak self] status in
            self?.showCardStatus(status: status)
        }
        router.push(module)
    }

    private func showCardStatus(status: Status) {
        var module = moduleFactory.showCardStatus(status: status)
        module.onReturnDidTap = { [unowned self] in
            self.router.popModule()
        }
        module.onCloseDidTap = { [unowned self] in
            self.router.popToRootModule()
        }
        router.push(module)
    }
}
