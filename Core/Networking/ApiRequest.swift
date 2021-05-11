import RxAlamofire
import RxSwift
import Alamofire
import Foundation

public struct ApiRequest: ApiRequestable {
    
    private let request: Alamofire.DataRequest
    private let logout: AuthStateObserver
    public init(url: URL, target: ApiTarget, manager: SessionManager, logout: AuthStateObserver) {
        let requestUrl = url
            .appendingPathComponent(target.servicePath)
            .appendingPathComponent(target.version.stringValue)
            .appendingPathComponent(target.path)
        let method = target.method.alamofireMethod
        let encoding: ParameterEncoding = method == .get ? URLEncoding.queryString : JSONEncoding.default
        request = manager.request(
            requestUrl,
            method: method,
            parameters: target.parameters,
            encoding: encoding,
            headers: target.headers
        ).response {
            #if DEBUG
            logger.response(
                code: $0.response?.statusCode,
                path: $0.response?.url?.absoluteString,
                data: $0.data,
                logLevel: Constants.networkLogLevel
            )
            #endif
        }
        self.logout = logout
    }
    
    public func cancel() {
        request.cancel()
    }
    
    public func run() -> Observable<Data> {
        #if DEBUG
        logger.request(
            method: request.request?.httpMethod,
            path: request.request?.url?.absoluteString,
            bodyData: request.request?.httpBody,
            logLevel: Constants.networkLogLevel
        )
        #endif
        request.resume()
        return request
            .validate { _, response, data in
                print(response.statusCode)

                guard let data = data else { return .failure(ApiResponseError.badServerResponse) }
                if 200..<300 ~= response.statusCode { return .success }
                
                guard let apiError = try? JSONDecoder().decode(ApiError.self, from: data) else {
                    if response.statusCode == 401 {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            logout.forceLogout()
                        }
                    }
                    return .failure(ApiResponseError.badServerResponse)
                }
                print(apiError)
                guard case let .exception(exception) = apiError else { return .failure(apiError) }
                
                var errorDescription = exception.error.message
                if response.statusCode >= 500 {
                    errorDescription = ApiResponseError.badServerResponse.localizedDescription
                }
                
                return .failure(
                    NSError(
                        domain: apiErrorDomain,
                        code: exception.code,
                        userInfo: [NSLocalizedDescriptionKey: errorDescription]
                    )
                )
            }
            .rx.responseData()
            .do(onError: { error in
                #if DEBUG
                logger.error("\(error)", errorType: .decodingError)
                #endif
            })
            .map { _, data in data }
    }
}

// MARK: Constants
private extension ApiRequest {
    
    enum Constants {
        #if DEBUG
        static let networkLogLevel: PilicanLogger.NetworkLogLevel = .verbose
        #endif
    }
}

public struct ApiPath {
    public static let userId = "_userId_"
    
    private init() {}
}

extension HTTPMethod {
    
    var alamofireMethod: Alamofire.HTTPMethod {
        switch self {
        case .get:
            return .get
        case .post:
            return .post
        case .put:
            return .put
        case .delete:
            return .delete
        case .patch:
            return .patch
        }
    }
}
