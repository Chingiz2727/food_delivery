import RxSwift

final class MyCardsViewModel: ViewModel {
    
    private let apiService: ApiService
    
    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    struct Input {
        let loadCards: Observable<Void>
        let removeCard: Observable<Int>
        let setMainCard: Observable<Int>
    }
    
    struct Output {
        let result: Observable<LoadingSequence<CardList>>
        let cardSetMain: Observable<LoadingSequence<CardList>>
        let cardSetRemove: Observable<LoadingSequence<Data>>
    }
    
    
    func transform(input: Input) -> Output {
        let cardsList = input.loadCards
            .flatMap { [unowned self] in
                self.apiService.makeRequest(to: AddCardApiTarget.cardList(cardName: ""))
                    .result(CardList.self)
                    .asLoadingSequence()
            }.share()
        
        let cardSetMain = input.setMainCard
            .flatMap { [unowned self] id in
                return self.apiService.makeRequest(to: AddCardApiTarget.setMainCard(cardID: id))
                    .result(CardList.self)
                    .asLoadingSequence()
            }.share()
        
        let removeCard = input.removeCard
            .flatMap { [unowned self] id in
                return self.apiService.makeRequest(to: AddCardApiTarget.deleteCard(cardID: id))
                    .result(CardList.self)
                    .asLoadingSequence()
            }.share()
        
        return .init(result: cardsList, cardSetMain: cardSetMain, cardSetRemove: removeCard)
    }
}
