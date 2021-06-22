//
//  QRPaymentTarget.swift
//  Pilican
//
//  Created by kairzhan on 3/26/21.
//

import Foundation

enum QRPaymentTarget: ApiTarget {
    case payByQRPartner(sig: String, orderId: String, createdAt: String, amount: Double, epayAmount: Double, comment: String,  useCashback: Bool)
    case payQr(orderId: String, useCashback: Bool)
    var version: ApiVersion {
        .custom("")
    }

    var mainUrl: String? {
        return "https://java.pillikan.org.kz/api"
    }
        
    var servicePath: String { "" }

    var path: String {
        switch self {
        case .payByQRPartner:
            return "transaction/pay"
        case .payQr:
            return "transaction/pay"
        }
    }

    var method: HTTPMethod {
        return .post
    }

    var parameters: [String : Any]? {
        switch self {
        case .payByQRPartner(let sig, let orderId, let createdAt, let amount, let epayAmount, let comment, let use):
            let params = [
                "transactionId": orderId,
                "retailId": sig,
                "amount": amount,
                "bonusAmount": epayAmount,
//                "terminalId": "sd:33:dg:ss:22:33",
                "useCashback": use
            ] as [String: Any]
            return params
        case .payQr(let orderId, let useCashback):
            return ["transactionId": orderId, "useCashback": useCashback]
        }
    }

    var stubData: Any {
        return [:]
    }

    var headers: [String : String]? {
        switch self {
        case .payByQRPartner,.payQr:
            return
                [
                    "clientId": "bW9iaWxl",
                    "appver": "3.2.1"
                ]
        }
    }
}
