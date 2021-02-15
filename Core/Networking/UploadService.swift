import Foundation
import Alamofire
import RxSwift

public protocol UploadService {
  typealias MultipartCompletion = (MultipartFormData) -> Void

  func upload<T: Decodable>(
    to apiTarget: ApiTarget,
    multipartCompletion: @escaping MultipartCompletion,
    completion: @escaping (Result<T>) -> Void
  )
}

public final class UploadServiceImpl: UploadService {

  private let decoder: JSONDecoder = {
    let decoder = JSONDecoder()
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    dateFormatter.calendar = Calendar(identifier: .iso8601)
    decoder.dateDecodingStrategy = .formatted(dateFormatter)
    return decoder
  }()

  private let url: URL
  private let sessionManager: SessionManager

  init(url: URL, sessionManager: SessionManager) {
    self.url = url
    self.sessionManager = sessionManager
    self.sessionManager.startRequestsImmediately = true
  }

  public func upload<T: Decodable>(
    to apiTarget: ApiTarget,
    multipartCompletion: @escaping MultipartCompletion,
    completion: @escaping (Result<T>) -> Void
  ) {

    let requestUrl = self.getFullUrl(from: apiTarget)

    sessionManager.upload(
      multipartFormData: multipartCompletion,
      to: requestUrl,
      method: apiTarget.method.alamofireMethod,
      headers: apiTarget.headers) { encodingResult in
        switch encodingResult {
        case .success(let request, _, _):
          request.responseJSON { [weak self] response in
            guard let `self` = self, let data = response.data else {
                completion(.error(ApiResponseError.badServerResponse))
              return
            }
            do {
              let object = try self.decoder.decode(T.self, from: data)
              completion(.success(object))
            } catch {
              completion(.error(ApiResponseError.badServerResponse))
            }
          }
        case .failure(let error):
          completion(.error(error))
        }
    }
  }

  private func getFullUrl(from target: ApiTarget) -> URL {
    return self.url
      .appendingPathComponent(target.servicePath)
      .appendingPathComponent(target.version.stringValue)
      .appendingPathComponent(target.path)
  }
}
