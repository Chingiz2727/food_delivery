import KeychainAccess
import Foundation
import UIKit

protocol AuthTokenService {
  var token: Token? { get }

  func set(token: Token?)
}

final class AuthTokenServiceImpl: AuthTokenService {

  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()
  private let keychain = Keychain(server: "https://pilican.kz", protocolType: .https)

  private(set) var token: Token? {
    get {
      guard
        let data = try? keychain.getData(Constants.tokenKey),
        let token = try? decoder.decode(Token.self, from: data) else { return nil }
        return token
    }
    set {
      let encodedData = try? encoder.encode(newValue)
      keychain[data: Constants.tokenKey] = encodedData
    }
  }
}

extension AuthTokenServiceImpl {
  func set(token: Token?) {
    self.token = token
  }
}

private extension AuthTokenServiceImpl {
  struct Constants {
    static let tokenKey = "stored_oauth_token_key"
  }
}
