import RxSwift

protocol AddCardApiService {
    func bindCard(cardHolderName: String, cryptoGram: String, cardName: String) -> Observable<LoadingSequence<BindCardModel>>
    func need3DSecure(url: String, model: BindCardModel) -> Observable<LoadingSequence<Data>>
    func post3ds(transactionId: String, threeDsCallbackId: String, paRes: String) -> Observable<LoadingSequence<Void>>
}

final class AddCardApiServiceImpl: AddCardApiService {
    
    private let apiService: ApiService
    
    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    func bindCard(cardHolderName: String, cryptoGram: String, cardName: String) -> Observable<LoadingSequence<BindCardModel>> {
        apiService.makeRequest(to: AddCardApiTarget.bindCard(cardHolderName: cardHolderName, cryptoGram: cryptoGram, cardName: cardName))
            .result(BindCardModel.self)
            .asLoadingSequence()
    }
    
    func need3DSecure(url: String, model: BindCardModel) -> Observable<LoadingSequence<Data>> {
        apiService.makeRequest(to: AddCardApiTarget.need3DSecure(url: url, model: model))
            .run()
            .asLoadingSequence()
    }
    
    func post3ds(transactionId: String, threeDsCallbackId: String, paRes: String) -> Observable<LoadingSequence<Void>> {
        apiService.makeRequest(to: AddCardApiTarget.post3ds(transactionId: transactionId, threeDsCallbackId: threeDsCallbackId, paRes: paRes))
            .result()
            .asLoadingSequence()
    }
}
