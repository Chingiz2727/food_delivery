//
//  QRPaymentViewModel.swift
//  Pilican
//
//  Created by kairzhan on 3/26/21.
//

import RxSwift

final class QRPaymentViewModel: ViewModel {

    struct Input {
        let makeRetailPay: Observable<Void>
        let amount: Observable<Double>
        let epayAmount: Observable<Double>
        let comment: Observable<String?>
        let loadInfo: Observable<Void>
        let useCashBack: Observable<Bool>
        let makeMuserPay: Observable<Void>
    }

    struct Output {
        let payByQRPartnerResponse: Observable<LoadingSequence<PayStatus>>
        let scanRetailResponse: Observable<LoadingSequence<ScanRetailResponse>>
        let muserResponse: Observable<LoadingSequence<PayByQRPartnerResponse>>
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
        let payResponse = input.makeRetailPay
            .withLatestFrom(Observable.combineLatest(input.amount, input.epayAmount, input.comment, input.useCashBack))
            .flatMap { [unowned self] amount, epay, comment, useCashBack -> Observable<LoadingSequence<PayStatus>> in
                let orderId: String
                if let transactionId = self.info.transactionId {
                    orderId = transactionId
                } else {
                    orderId = "\(self.info.orderId)"
                }
                let createdAt = String(NSDate().timeIntervalSince1970).split(separator: ".")[0]
                let token = userSessionStorage.accessToken
                let substring = ((token! as NSString).substring(with: NSMakeRange(11, 21)) as NSString).substring(with: NSMakeRange(0, 10))
                let sig = ((substring + String(amount) + String(createdAt) + String(self.info.orderId)).toBase64()).md5()
                return apiService.makeRequest(to: QRPaymentTarget.payByQRPartner(
                                                sig: "\(self.info.retail.id)",
                                                orderId: "\(orderId)",
                                                createdAt: "\(createdAt)",
                                                amount: Double(amount),
                                                epayAmount: Double(epay),
                                                comment: comment ?? "",
                                                useCashback: useCashBack))
                    .result(PayStatus.self)
                    .asLoadingSequence()
            }.share()
        
        let muserResponse = input.makeMuserPay
            .withLatestFrom(Observable.combineLatest(input.amount, input.epayAmount, input.comment))
            .flatMap { [unowned self] amount, epay, comment -> Observable<LoadingSequence<PayByQRPartnerResponse>> in
                let orderId = self.info.orderId
                let createdAt = String(NSDate().timeIntervalSince1970).split(separator: ".")[0]
                let token = userSessionStorage.accessToken
                let substring = ((token! as NSString).substring(with: NSMakeRange(11, 21)) as NSString).substring(with: NSMakeRange(0, 10))
                let sig = ((substring + String(amount) + String(createdAt) + String(self.info.orderId)).toBase64()).md5()
                return apiService.makeRequest(to: MuserTarget.payByQRPartner(
                                                sig: sig,
                                                orderId: "\(orderId)",
                                                createdAt: "\(createdAt)",
                                                amount: Double(amount),
                                                epayAmount: Double(epay),
                                                comment: comment ?? ""))
                    .result(PayByQRPartnerResponse.self)
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
        
        return .init(payByQRPartnerResponse: payResponse, scanRetailResponse: scanRetailResponse, muserResponse: muserResponse)
    }
}

struct PayStatus: Codable {
    let success: Bool
    let data: Int?
}
