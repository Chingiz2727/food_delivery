import Foundation
import Alamofire
import RxSwift

public protocol PilicanRequestRetrier: RequestRetrier {

  typealias RequestRetryCompletion = (_ shouldRetry: Bool, _ timeDelay: TimeInterval) -> Void

  func shouldRetryRequestFailed(with error: Error, completion: @escaping RequestRetryCompletion)
}

final class PilicanRequestRetrierImpl: PilicanRequestRetrier {

  var authService: AuthenticationService!

  private var lock = NSLock()
  private var isRefreshing = false
  private var requestsToRetry = [RequestRetryCompletion]()

  private let disposeBag = DisposeBag()

  func shouldRetryRequestFailed(with error: Error, completion: @escaping RequestRetryCompletion) {

    lock.lock()

    defer {
      lock.unlock()
    }

    guard case ApiTokenError.accessExpired = error else {
      completion(false, 0.0)
      return
    }

    requestsToRetry.append(completion)

    if isRefreshing { return }

    isRefreshing = true
    #if DEBUG
    logger.info("Refreshing token...")
    #endif
  }

  // MARK: RequestRetrier

  public func should(
    _ manager: SessionManager,
    retry request: Request,
    with error: Error,
    completion: @escaping RequestRetryCompletion
  ) {
    shouldRetryRequestFailed(with: error, completion: completion)
  }
}

enum ApiTokenError: Error {
  case accessExpired
  case refreshExpired
}
