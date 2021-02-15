import Foundation
import Alamofire
import Swinject

public protocol ApiServicesAssembly {

  func registerNetworkLayer(in container: Container)
}

public struct ApiServicesAssemblyImpl: ApiServicesAssembly {

  public init() {}

  public func registerNetworkLayer(in container: Container) {
    container.register(RequestAdapter.self) { resolver in
      var adapter = PilicanRequestAdapter()
      adapter.authService = resolver.resolve(AuthenticationService.self)!
      adapter.configService = resolver.resolve(ConfigService.self)!
      return adapter
    }

    container.register(RequestRetrier.self) { resolver in
      let retrier = PilicanRequestRetrierImpl()
      retrier.authService = resolver.resolve(AuthenticationService.self)
      return retrier
    }

    container.register(SessionManager.self) { _ in return SessionManager() }
      .initCompleted { resolver, manager in
        manager.startRequestsImmediately = false
        manager.adapter = resolver.resolve(RequestAdapter.self)
        manager.retrier = resolver.resolve(RequestRetrier.self)
      }
      .inObjectScope(.container)

    container.register(ApiRequestable.self) { (resolver, target: ApiTarget, stubbed: Bool) in
      if stubbed {
        return StubApiRequest(target: target, behaviour: .afterDelay(1))
      } else {
        let sessionManager = resolver.resolve(SessionManager.self)!
        let configService = resolver.resolve(ConfigService.self)!

        return ApiRequest(url: configService.apiUrl, target: target, manager: sessionManager)
      }
    }
    .inObjectScope(.transient)

    container.register(ApiService.self) { resolver in
      let sessionManager = resolver.resolve(SessionManager.self)!
      return ApiServiceImpl(sessionManager: sessionManager) { target, stubbed in
        return resolver.resolve(ApiRequestable.self, arguments: target, stubbed)!
      }
    }
    .inObjectScope(.container)

    container.register(UploadService.self) { resolver in
      let sessionManager = resolver.resolve(SessionManager.self)!
      let configService = resolver.resolve(ConfigService.self)!
      return UploadServiceImpl(url: configService.apiUrl, sessionManager: sessionManager)
    }
    .inObjectScope(.container)
  }
}
