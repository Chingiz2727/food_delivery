import Moya

final class MoyaApiService {
    static let shared = MoyaApiService()
    let cardService = MoyaProvider<MoyaAddCardApiTarget>(plugins: plugins)

    func pass3DSecure(url: String, model: BindCardModel, token: String, completion: @escaping (String?, Error?) -> ()) {
        cardService.request(.need3DSecure(url: url, model: model, token: token)) { (result) in
            if let value = result.value {
                completion(String.init(data: value.data, encoding: .utf8) ?? "", nil)
            } else {
                if let e = try? JSONDecoder().decode(ErrorResponse.self, from: result.value!.data) {
                    completion("", e)
                }
            }
        }
    }
    
    func post3Ds(transactionId: String,
                 threeDsCallbackId: String,
                 paRes: String,
                 token: String,
                 completion: @escaping (_ result: Status?, _ error: ErrorResponse?) -> ()) {
        
        let post3dService = MoyaAddCardApiTarget.post3ds(transactionId: transactionId, threeDsCallbackId: threeDsCallbackId, paRes: paRes, token: token)
        return fetchPost3D(service: post3dService, completion: completion)
    }
    
    func fetchPost3D(service: MoyaAddCardApiTarget, completion: @escaping (Status?, ErrorResponse?) -> ()) {
        cardService.request(service) { result in
            switch result {
            case let .success(moyaResponse):
                if let url = moyaResponse.response?.url?.path {
                    completion(Status.init(rawValue: url), nil)
                }
            default:
                completion(nil,ErrorResponse.init())
                break
            }
//            response.response
        }
    }
    
    func replenishBalance(sig: String,
                          createdAt: String,
                          amount: Float,
                          completion: @escaping (_ code: OAuthResponse?, _ error: ErrorResponse?) -> ()) {
        let createOrder = MoyaAddCardApiTarget.replenishBalance(sig: sig, amount: amount, createdAt: createdAt)
        cardService.request(createOrder) { result in
            print(result)
        }
    }
    
    func changePassword(
                          password: String,
                          password1: String,
                          completion: @escaping (_ code: ResponseStatus?, _ error: ErrorResponse?) -> ()) {
        let createOrder = MoyaAddCardApiTarget.changePassword(password: password, password1: password1)
        cardService.request(createOrder) { result in
            switch result {
            case .failure(let error):
                completion(nil,ErrorResponse.init(name: "Ошибка", message: error.localizedDescription, code: 404, status: 0))
            case .success(let response):
                if let e = try? JSONDecoder().decode(ResponseStatus.self, from: response.data) {
                    completion(e, nil)
                }
            }
            print(result)
        }
    }
}

enum Status: String {
    case succes = "/success"
    case failure = "/fail"
}

struct ErrorResponse: Error, Decodable  {
    
    let message: String
    let code: Int
    let status: Int
    let name: String
    
    init() {
        self.name = "Сообщение"
        self.message = "Произошла неизвестная ошибка. Попробуйте сделать Ваш запрос позже";
        self.code = 0;
        self.status = 0;
    }
    
    init(name: String, message: String, code: Int, status: Int) {
        self.name = name
        self.message = message;
        self.code = code;
        self.status = status;
    }
    
    init?(json: [String: Any]) {
        let _name = json["name"] as? String
        let _message = json["message"] as? String
        let _code = json["code"] as? Int
        let _status = json["status"] as? Int
        self.name = _name ?? ""
        self.message = _message ?? ""
        self.code = _code ?? 0
        self.status = _status ?? 0
     
    }
    private enum CodingKeys: String, CodingKey {
        case name
        case message
        case code
        case status
    }
    
    var localizedDescription: String {
        return message;
    }
}

let plugins: [PluginType] = [NetworkLoggerPlugin(verbose: true, responseDataFormatter: JSONResponseDataFormatter)]
// MARK: - Provider setup
private func JSONResponseDataFormatter(data: Data) -> Data {
    do {
        let dataAsJSON = try JSONSerialization.jsonObject(with: data as Data, options: [])
        let prettyData = try JSONSerialization.data(withJSONObject: dataAsJSON, options: .prettyPrinted)
        return prettyData as Data
    } catch {
        return data
    }
}
// MARK: - Provider support
private extension String {
    var URLEscapedString: String {
        return self.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlHostAllowed)!
    }
}
