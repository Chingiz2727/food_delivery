import Foundation

enum AuthTarget: ApiTarget {
    case getSmsCode (phone: String)
    case verifySmsCode (phone: String, code: String)
    case loginUser (phone: String, password: String)
    case register(username: String, password: String, fullName: String, cityId: Int, promo: String?)
    case updateProfile( sex: String, firstName: String, birthday: String, cityId: Int)
    case getAuthSmsCode(phone: String)
    case firbaseToken(fireBaseToken: String)

    var servicePath: String { "" }

    var version: ApiVersion {
        .custom("")
    }

    var path: String {
        switch self {
        case .getSmsCode:
            return "api/v1/auth/sms"
        case .getAuthSmsCode:
            return "api/v1/auth/reset-password-request"
        case .verifySmsCode:
            return "api/v1/auth/auth-sms"
        case .register:
            return "api/v1/auth/sign-up"
        case .loginUser:
            return "s/v1/manual/token/mobile"
        case .updateProfile:
            return "v1/profile/edit"
        case .firbaseToken:
            return "api/user/f-token"
        }
    }

    var method: HTTPMethod {
        return .post
    }

    var parameters: [String: Any]? {
        switch self {
        case .loginUser(let phone, let password):
            return ["userName": phone, "password": password]
        case .getAuthSmsCode(let phone):
            return ["test": phone]
        case let .register(username, password, fullName, cityId, promo):
            let params = [
                "username": username,
                "password": password,
                "fullName": fullName,
                "cityId": cityId,
                "promo": promo
            ] as [String: Any]
            return params
        case .firbaseToken(let fireBaseToken):
            return ["": fireBaseToken]
        default:
            return [:]
        }
    }

    var stubData: Any {
        return [:]
    }

    var headers: [String: String]? {
        switch self {
        case .loginUser:
            return
                [
                    "clientId": "bW9iaWxl",
                    "appver": "3.0.2"
                ]
        default:
            return [:]
        }
    }
}
