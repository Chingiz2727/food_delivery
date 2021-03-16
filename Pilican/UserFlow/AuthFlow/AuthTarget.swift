import Foundation

enum AuthTarget: ApiTarget {
    case getSmsCode (phone: String)
    case verifySmsCode (phone: String, code: String)
    case loginUser (phone: String, password: String)
    case register(username: String, password: String, fullName: String, cityId: Int, promo: String?)
    case updateProfile( sex: String, firstName: String, birthday: String, cityId: Int)
    case getAuthSmsCode(phone: String)
    case firbaseToken(fireBaseToken: String)
    case changePassword(newPassword: String, acceptPassword: String)

    var servicePath: String { "" }

    var version: ApiVersion {
        .custom("")
    }

    var path: String {
        switch self {
        case .getSmsCode:
            return "v1/auth/sms"
        case .getAuthSmsCode:
            return "v1/auth/reset-password-request"
        case .verifySmsCode:
            return "v1/auth/auth-sms"
        case .register:
            return "v1/auth/sign-up"
        case .loginUser:
            return "s/v1/manual/token/mobile"
        case .updateProfile:
            return "v1/profile/edit"
        case .firbaseToken:
            return "api/user/f-token"
        case .changePassword:
            return "v1/profile/change-password"
        }
    }

    var method: HTTPMethod {
        return .post
    }

    var parameters: [String: Any]? {
        switch self {
        case .loginUser(let phone, let password):
            return ["userName": phone, "password": password]
        case .getSmsCode:
            return ["test": "value"]
        case let .register(username, password, fullName, cityId, promo):
            let params = [
                "username": username.toBase64(),
                "password": password.toBase64(),
                "fullName": fullName.toBase64(),
                "cityId": "\(cityId)".toBase64(),
                "promo": promo?.toBase64()
            ] as [String: Any]
            return params
        case let .verifySmsCode(phone, code):
            let params = [
                "userName": phone,
                "password": code
            ]
            return params
        case .firbaseToken(let fireBaseToken):
            return ["": fireBaseToken]
        case .getAuthSmsCode:
            return ["test": "value"]
        case .changePassword(let newPassword, let acceptPassword):
            return ["password": newPassword, "password2": acceptPassword]
        default:
            return [:]
        }
    }

    var stubData: Any {
        return [:]
    }

    var headers: [String: String]? {
        switch self {
        case .loginUser, .register, .verifySmsCode, .changePassword:
            return
                [
                    "clientId": "bW9iaWxl",
                    "appver": "3.0.0"
                ]
        case let .getSmsCode(phone):
            return [
                "userName": phone.toBase64()
            ]
        case let .getAuthSmsCode(phone):
            return [
                "userName": phone.toBase64()
            ]
        default:
            return [:]
        }
    }
}
