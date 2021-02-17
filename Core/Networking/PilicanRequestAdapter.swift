import Foundation
import Alamofire

public struct PilicanRequestAdapter: RequestAdapter {

  public var authService: AuthenticationService!
  public var configService: ConfigService!

  public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
    var resultRequest = urlRequest
//    resultRequest.url = adaptedUrl(resultRequest.url)
//        resultRequest.setValue(configService.redirectionUrl.absoluteString, forHTTPHeaderField: "X-User-Host")

//    resultRequest.setValue(String(configService.appVersion), forHTTPHeaderField: "X-User-Version")
//    resultRequest.setValue("ru", forHTTPHeaderField: "Accept-Language")
//    resultRequest.setValue("ios_app", forHTTPHeaderField: "X-User-Platform")
//    resultRequest.setValue("appver", forHTTPHeaderField: "3.0.0")

//    if let authHeader = urlRequest.value(forHTTPHeaderField: "Authorization"),
//      authHeader.contains("Basic") || authHeader.contains("Social") {
//      // Its OAuth request, shouldn't add Authentication header
//      return resultRequest
//    }
    if let token = authService.token, let accessToken = token.accessToken {
      resultRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
    }
    return resultRequest
  }

  private func adaptedUrl(_ url: URL?) -> URL? {
    guard let url = url else { return nil }
//    guard let userId = authService.token?.userId else { return url }
    return URL(string: url.absoluteString.replacingOccurrences(of: ApiPath.userId, with: ""))
  }
}
