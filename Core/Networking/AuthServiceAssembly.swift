import Foundation
import Swinject

public protocol AuthServiceAssembly {

  func registerAuthService(in container: Container)
}

public struct AuthServiceAssemblyImpl: AuthServiceAssembly {

  public init() {}

  public func registerAuthService(in container: Container) {
    registerAuthTokenService(in: container)
    registerClassicAuthService(in: container)
    registerAccessCodeService(in: container)
  }

  private func registerAuthTokenService(in container: Container) {
    container.register(AuthTokenService.self) { _ in
      AuthTokenServiceImpl()
    }
    .inObjectScope(.container)
  }

  private func registerAccessCodeService(in container: Container) {
    container.register(AccessCodeService.self) { _ in
      let service = AccessCodeServiceImpl()
      return service
    }
    .inObjectScope(.container)
  }

  private func registerClassicAuthService(in container: Container) {
    container.register(AuthenticationService.self) { resolver in
      let apiService = resolver.resolve(ApiService.self)!
      let configService = resolver.resolve(ConfigService.self)!
      let authTokenService = resolver.resolve(AuthTokenService.self)!

      return AuthenticationServiceImpl(
        apiService: apiService,
        configService: configService,
        authTokenService: authTokenService
      )
    }
    .inObjectScope(.container)
  }
}
