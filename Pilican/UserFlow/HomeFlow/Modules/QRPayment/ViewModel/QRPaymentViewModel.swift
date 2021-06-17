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
        let loadInfo: Observable<Void>
    }

    struct Output {
        let payByQRPartnerResponse: Observable<LoadingSequence<PayStatus>>
        let scanRetailResponse: Observable<LoadingSequence<ScanRetailResponse>>
    }
    var info: ScanRetailResponse
    private let userSessionStorage: UserSessionStorage
    private let apiService: ApiService

    init(apiService: ApiService, info: ScanRetailResponse, userSessionStorage: UserSessionStorage) {
        self.apiService = apiService
        self.userSessionStorage = userSessionStorage
        self.info = info
    }

    func transform(input: Input) -> Output {
        let payResponse = input.payTapped
            .withLatestFrom(Observable.combineLatest(input.amount, input.epayAmount, input.comment))
            .flatMap { [unowned self] amount, epay, comment -> Observable<LoadingSequence<PayStatus>> in
                let orderId = self.info.orderId
                let createdAt = String(NSDate().timeIntervalSince1970).split(separator: ".")[0]
                let token = userSessionStorage.accessToken
                let substring = ((token! as NSString).substring(with: NSMakeRange(11, 21)) as NSString).substring(with: NSMakeRange(0, 10))
                let sig = ((substring + String(amount) + String(createdAt) + String(self.info.orderId)).toBase64()).md5()
                return apiService.makeRequest(to: QRPaymentTarget.payByQRPartner(
                                                sig: sig,
                                                orderId: "\(orderId)",
                                                createdAt: "\(createdAt)",
                                                amount: Double(amount),
                                                epayAmount: Double(epay),
                                                comment: comment ?? ""))
                    .result(PayStatus.self)
                    .asLoadingSequence()
            }.share()
        
        
        let scanRetailResponse = input.loadInfo
            .flatMap { [unowned self] _ -> Observable<ScanRetailResponse> in
                let createdAt = String(NSDate().timeIntervalSince1970).split(separator: ".")[0]
                let token = self.userSessionStorage.accessToken
                let substring = ((token! as NSString).substring(with: NSMakeRange(11, 21)) as NSString).substring(with:  NSMakeRange(0, 10))
                let sig = ((substring + String(createdAt) + String(info.retail.id ?? 1)).toBase64()).md5()
                return self.apiService.makeRequest(to: CameraTarget.retailScan(
                                                    retailId: info.retail.id ?? 1,
                                                    createdAt: String(createdAt),
                                        sig: sig))
                    .result(ScanRetailResponse.self)
            }.asLoadingSequence()
        
        return .init(payByQRPartnerResponse: payResponse, scanRetailResponse: scanRetailResponse)
    }
}

struct PayStatus: Codable {
    let success: Bool
    let data: Int
}
