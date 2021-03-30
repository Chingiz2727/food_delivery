//
//  QRPaymentViewModel.swift
//  Pilican
//
//  Created by kairzhan on 3/26/21.
//

import RxSwift

final class QRPaymentViewModel: ViewModel {
    
    struct Input {
        let payTapped: Observable<Void>
        let amount: Observable<Double>
        let epayAmount: Observable<Double>
        let comment: Observable<String?>
    }

    struct Output {
        let payByQRPartnerResponse: Observable<LoadingSequence<PayByQRPartnerResponse>>
    }
    let info: ScanRetailResponse
    private let tokenService: AuthTokenService
    private let apiService: ApiService

    init(apiService: ApiService, info: ScanRetailResponse, tokenService: AuthTokenService) {
        self.apiService = apiService
        self.tokenService = tokenService
        self.info = info
    }

    func transform(input: Input) -> Output {
        let payResponse = input.payTapped
            .withLatestFrom(Observable.combineLatest(input.amount,input.epayAmount,input.comment))
            .flatMap { [unowned self] amount, epay, comment -> Observable<PayByQRPartnerResponse> in
                let orderId = self.info.orderId
                let createdAt = String(NSDate().timeIntervalSince1970).split(separator: ".")[0]
                let token = tokenService.token?.accessToken
                let substring = ((token! as NSString).substring(with: NSMakeRange(11, 21)) as NSString).substring(with: NSMakeRange(0, 10))
                let sig = ((substring + String(amount) + String(createdAt) + String(self.info.orderId)).toBase64()).md5()
                return apiService.makeRequest(to: QRPaymentTarget.payByQRPartner(
                                                sig: sig,
                                                orderId: "\(orderId)",
                                                createdAt: "\(createdAt)",
                                                amount: Double(amount),
                                                epayAmount: Double(epay),
                                                comment: comment ?? ""))
                    .result(PayByQRPartnerResponse.self)
            }.asLoadingSequence()
        return .init(payByQRPartnerResponse: payResponse)
    }
}
