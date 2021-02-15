import KeychainAccess
import Foundation
import UIKit

protocol AuthTokenService {
  var token: OAuthToken? { get }

  func set(token: OAuthToken?)
}

final class AuthTokenServiceImpl: AuthTokenService {

  private let encoder = JSONEncoder()
  private let decoder = JSONDecoder()
  private let keychain = Keychain(server: "https://pilican.kz", protocolType: .https)

  private(set) var token: OAuthToken? {
    get {
      guard
        let data = try? keychain.getData(Constants.tokenKey),
        let token = try? decoder.decode(OAuthToken.self, from: data) else { return nil }
      return token
    }
    set {
      let encodedData = try? encoder.encode(newValue)
      keychain[data: Constants.tokenKey] = encodedData
    }
  }

  init() {
    clearTokenIfNeeded()
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(clearTokenIfNeeded),
      name: UIApplication.didBecomeActiveNotification,
      object: nil
    )
  }

  @objc private func clearTokenIfNeeded() {
    if let expDate = token?.refreshTokenExpDate, expDate < Date() {
      token = nil
    }
  }
}

extension AuthTokenServiceImpl {
  func set(token: OAuthToken?) {
    self.token = token
  }
}

private extension AuthTokenServiceImpl {
  struct Constants {
    static let tokenKey = "stored_oauth_token_key"
  }
}
