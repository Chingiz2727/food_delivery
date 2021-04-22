enum AddCardApiTarget: ApiTarget {
    
    case cardList(cardName: String)
    case deleteCard(cardID: Int)
    case setMainCard(cardID: Int)
    case addCard(cardName: String)
    case bindCard(cardHolderName: String, cryptoGram: String, cardName: String)
    case need3DSecure(url: String, model: BindCardModel)
    case post3ds(transactionId: String, threeDsCallbackId: String, paRes: String)
    
    var version: ApiVersion {
        return .custom("")
    }
    
    var mainUrl: String? {
        switch self {
        case .post3ds:
            return "https://api.cloudpayments.ru/"
        case .need3DSecure(let url, _ ):
            return url
        default:
            return AppEnviroment.baseURL
        }
    }
    
    var servicePath: String {
        return ""
    }
    
    var path: String {
        switch self {
        case .addCard:
            return "a/cb/card/add"
        case .cardList:
            return "a/cb/card/list"
        case .deleteCard:
            return "a/cb/card/delete"
        case .setMainCard:
            return "a/cb/card/set-main"
        case .bindCard:
            return "a/cb/card/v2/add"
        case .need3DSecure:
            return ""
        case .post3ds:
            return "payments/ThreeDSCallback"
        }
    }
    
    var method: HTTPMethod {
        return .post
    }
    
    var parameters: [String : Any]? {
        switch self {
        case .cardList( let cardName), .addCard(let cardName):
            return ["cardName": cardName]
        case .deleteCard(let cardID):
            return ["cardId": cardID]
        case .setMainCard(let cardID):
            return ["cardId": cardID]
        case .bindCard(let cardHolderName, let cryptoGram, let cardName):
            let params = [
                "cardHolderName": cardHolderName,
                "cryptogram": cryptoGram,
                "cardName": cardName
            ]
            return params
        case .need3DSecure(_  , let model):
            let params = [
                "PaReq": model.paReq ?? "",
                "TermUrl": model.termUrl ?? "",
                "MD": model.mD ?? ""
            ] as [String : Any]
            return params
        case let .post3ds(transactionId, threeDsCallbackId, paRes):
            let mdParams = ["TransactionId": transactionId,
                            "ThreeDsCallbackId": threeDsCallbackId,
                            "SuccessUrl": "https://demo.cloudpayments.ru/success",
                            "FailUrl": "https://demo.cloudpayments.ru/fail"]
            if let mdParamsData = try? JSONSerialization.data(withJSONObject: mdParams, options: .sortedKeys),
            let mdParamsString = String.init(data: mdParamsData, encoding: .utf8) {
                let params = ["MD": mdParamsString, "PaRes": paRes]
                return params
            }
        }
        return nil
    }

    var stubData: Any {
        return [:]
    }
}
