import Foundation
import Alamofire

public struct PilicanRequestAdapter: RequestAdapter {

  public var authService: AuthenticationService!
  public var configService: ConfigService!

  public func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
    var resultRequest = urlRequest
//    resultRequest.url = adaptedUrl(resultRequest.url)
//        resultRequest.setValue(configService.redirectionUrl.absoluteString, forHTTPHeaderField: "X-User-Host")

    resultRequest.setValue(String(AppEnviroment.appVersion), forHTTPHeaderField: "appver")
    if let token = authService.token {
      resultRequest.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
    }
    return resultRequest
  }

  private func adaptedUrl(_ url: URL?) -> URL? {
    guard let url = url else { return nil }
    return URL(string: url.absoluteString.replacingOccurrences(of: ApiPath.userId, with: ""))
  }
}
