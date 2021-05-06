import Foundation

enum AuthTarget: ApiTarget {
    case getSmsCode (phone: String)
    case verifySmsCode (phone: String, code: String)
    case loginUser (phone: String, password: String)
    case register(username: String, password: String, fullName: String, cityId: Int, promo: String?)
    case updateProfile(username: String, sex: String, fullName: String, birthday: String, cityId: String)
    case getAuthSmsCode(phone: String)
    case firbaseToken(fireBaseToken: String)
    case changePassword(newPassword: String, acceptPassword: String)
    case changePin(password: String, newPin: String, acceptPin: String)

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
        case .changePin:
            return "v1/profile/change-pin"
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
        case let .updateProfile(username, sex, fullName, birthday, cityId):
            let params = [
                "username": username,
                "sex": sex,
                "fullName": fullName,
                "birthday": birthday,
                "cityId": cityId
            ]
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
        case let .changePin(password, newPin, acceptPin):
            return ["password": password, "pin1": newPin, "pin2": acceptPin]
        }
    }

    var stubData: Any {
        return [:]
    }

    var headers: [String: String]? {
        switch self {
        case .loginUser, .register, .verifySmsCode, .updateProfile, .changePin:
            return
                [
                    "clientId": "bW9iaWxl"
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
