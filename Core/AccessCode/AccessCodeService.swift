import KeychainAccess
import Foundation

public struct AccessCodeConfiguration {
  static let codeLength = 4
  static let tryCount = 5
}

public protocol AccessCodeService {
  var phone: String? { get set }
  var password: String? { get set }
  var accessCode: String? { get set }
  var isAccessCodeTurned: Bool { get set }
  var name: String? { get set }
  func clearAccessCodeDatas()
}

public final class AccessCodeServiceImpl: AccessCodeService {
  private var keychain: Keychain {
    Keychain(server: "https://pilican.kz", protocolType: .https)
  }

  public var phone: String? {
    get {
      return keychain[KeychainKey.phone]
    }
    set {
      keychain[KeychainKey.phone] = newValue
    }
  }

  public var password: String? {
    get {
      return keychain[KeychainKey.password]
    }
    set {
      keychain[KeychainKey.password] = newValue
    }
  }

  public var name: String? {
    get {
      return UserDefaults.standard.string(forKey: AccessCodeKey.accessCodeName)
    }
    set {
      UserDefaults.standard.set(newValue, forKey: AccessCodeKey.accessCodeName)
    }
  }

  public var accessCode: String? {
    get {
      return keychain[KeychainKey.accessCode]
    }
    set {
      keychain[KeychainKey.accessCode] = newValue
    }
  }

  public var isAccessCodeTurned: Bool {
    get {
      return UserDefaults.standard.bool(forKey: AccessCodeKey.isAccessCodeTurned)
    }
    set {
      UserDefaults.standard.set(newValue, forKey: AccessCodeKey.isAccessCodeTurned)
    }
  }

  public func clearAccessCodeDatas() {
    self.accessCode = nil
    self.phone = nil
    self.password = nil
    self.isAccessCodeTurned = false
  }
}

private struct AccessCodeKey {
  static let isAccessCodeTurned = "is_access_code_turned"
  static let accessCodeName = "access_code_name"
}

private struct KeychainKey {
  static let phone = "access_code_phone"
  static let password = "access_code_password"
  static let accessCode = "access_code"
}
