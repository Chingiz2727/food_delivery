import Foundation

public struct OAuthToken: Codable {
  public var accessToken: String?
  let expiresIn: Int
  let refreshExpiresIn: Int
  public var refreshToken: String
  let scope: String
  let sessionState: String
  public let tokenType: String
  let refreshTokenExpDate: Date
}
