import CloudKit
import SDK_iOS
import Moya
import RxSwift

final class AddCardViewModel: ViewModel {
    
    private let addCardApiService: AddCardApiService
    let sessionStorage: UserSessionStorage

    init(addCardApiService: AddCardApiService, sessionStorage: UserSessionStorage) {
        self.addCardApiService = addCardApiService
        self.sessionStorage = sessionStorage
    }
    
    struct Input {
        let cardName: Observable<String>
        let holderName: Observable<String>
        let cardNumber: Observable<String>
        let cvv: Observable<String>
        let date: Observable<String>
        let addTapped: Observable<Void>
        let makeCryptogram: Observable<BindCardModel>
    }
    
    struct Output {
        let makeCryptogram: Observable<LoadingSequence<BindCardModel>>
        let need3ds: Observable<LoadingSequence<Data>>
    }
    
    func transform(input: Input) -> Output {
        let card = Card()

        let makeCryptogram = input.addTapped
            .withLatestFrom(Observable.combineLatest(
                input.cardName,
                input.holderName,
                input.cardNumber,
                input.cvv,
                input.date
            )).flatMap { [unowned self] cardName, userName, cardNumber, cvv, date -> Observable<LoadingSequence<BindCardModel>> in
                let cryptoGram = card.makeCryptogramPacket(cardNumber, andExpDate: date, andCVV: cvv, andMerchantPublicID: AppEnviroment.cloudPaymentId)
                return self.addCardApiService.bindCard(cardHolderName: userName, cryptoGram: cryptoGram ?? "", cardName: cardName)
            }
        
        let need3ds = input.makeCryptogram
            .flatMap { [unowned self] card -> Observable<LoadingSequence<Data>> in
                return self.addCardApiService.need3DSecure(url: card.acsUrl ?? "", model: card)
            }
        return .init(makeCryptogram: makeCryptogram, need3ds: need3ds)
    }
}
