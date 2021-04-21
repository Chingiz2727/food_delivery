import RxSwift

final class AddCardViewModel: ViewModel {
    
    struct Input {
        let cardName: Observable<String>
        let holderName: Observable<String>
        let cardNumber: Observable<String>
        let cvv: Observable<String>
        let date: Observable<String>
        let addTapped: Observable<Void>
    }
    
    struct Output {
        
    }
    
    func transform(input: Input) -> Output {
        return .init()
    }
}
