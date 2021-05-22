import Moya

enum MoyaAddCardApiTarget {
    case need3DSecure(url: String, model: BindCardModel, token: String)
    case post3ds(transactionId: String, threeDsCallbackId: String, paRes: String, token: String)
    case replenishBalance(sig: String, amount: Float, createdAt: String)
}

extension MoyaAddCardApiTarget: TargetType {
    var baseURL: URL {
        switch self {
        case .need3DSecure(let url, _, _):
            guard let url = URL(string: url) else { fatalError("baseURL could not be configured.") }
            return url
        case .post3ds:
            guard let url = URL(string: "https://api.cloudpayments.ru/") else { fatalError("baseURL could not be configured.") }
            return url
        case .replenishBalance:
            return URL(string: AppEnviroment.baseURL)!
        }
    }
    var path: String {
        switch self {
        case .need3DSecure:
            return ""
        case .post3ds:
            return "payments/ThreeDSCallback"
        case .replenishBalance:
            return "a/cb/purchase/replenish"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .need3DSecure, .post3ds, .replenishBalance:
            return .post
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var task: Task {
        var taskValue = [String: Any]()
        switch self {
        case .need3DSecure(_  , let model, _):
            taskValue["PaReq"] = model.paReq
            taskValue["TermUrl"] = model.termUrl
            taskValue["MD"] = model.mD
            
        case let .post3ds(transactionId, threeDsCallbackId, paRes, _):
            
            let mdParams = ["TransactionId": transactionId,
                            "ThreeDsCallbackId": threeDsCallbackId,
                            "SuccessUrl": "https://demo.cloudpayments.ru/success",
                            "FailUrl": "https://demo.cloudpayments.ru/fail"]
            if let mdParamsData = try? JSONSerialization.data(withJSONObject: mdParams, options: .sortedKeys),
               let mdParamsString = String.init(data: mdParamsData, encoding: .utf8) {
                taskValue["MD"] = mdParamsString
                taskValue["PaRes"] = paRes
            }
        case .replenishBalance(let sig,let amount,let createdAt):
            taskValue["sig"] = sig
            taskValue["amount"] = amount
            taskValue["createdAt"] = createdAt
        }
        return .requestParameters(parameters: taskValue, encoding: JSONEncoding.default)
    }
    
    var headers: [String : String]? {
        var httpHeaders = [String: String]()
        switch self {
        case .need3DSecure(_, _ ,let token), .post3ds(_, _ ,_ , let token):
            httpHeaders["Content-Type"] = "application/json; charset=utf-8"
            httpHeaders["authorization"] = "Bearer \(token)"
        case .replenishBalance:
            let users = assembler.resolver.resolve(UserSessionStorage.self)!
            httpHeaders["appver"] = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            httpHeaders["authorization"] = "Bearer " + users.accessToken!
            httpHeaders["Content-Type"] = "application/json"
        }
        return httpHeaders
    }
}

