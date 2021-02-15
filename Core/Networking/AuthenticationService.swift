import RxSwift
import RxRelay
import Foundation

public protocol AuthenticationService {
    var token: OAuthToken! { get }
    var authenticated: Observable<Bool> { get }
    
    func getSMSCode(_ phone: String) -> Observable<Void>
    func login(phone: String, password: String) -> Observable<LoadingSequence<OAuthToken>>
    func createUser(phone: String, fullName: String, password: String, cityId: Int, promo: String?) ->  Observable<LoadingSequence<OAuthToken>>
}

public protocol LogoutListener {
    func cleanUpAfterLogout()
}

public final class AuthenticationServiceImpl: AuthenticationService {
    
    public var token: OAuthToken! {
        didSet {
            authenticatedRelay.accept(token != nil)
            authTokenService.set(token: token)
        }
    }
    
    public var authenticated: Observable<Bool> {
        return authenticatedRelay.asObservable().distinctUntilChanged()
    }
    
    private var authenticatedRelay = BehaviorRelay(value: false)
    
    private let apiService: ApiService
    private let configService: ConfigService
    private let authTokenService: AuthTokenService
    
    private var logoutListeners = [LogoutListener]()
    
    init(
        apiService: ApiService,
        configService: ConfigService,
        authTokenService: AuthTokenService
    ) {
        self.apiService = apiService
        self.configService = configService
        self.authTokenService = authTokenService
        
        token = authTokenService.token
        authenticatedRelay.accept(token != nil)
    }
    
    public func getSMSCode(_ phone: String) -> Observable<Void> {
        return apiService.makeRequest(to: AuthTarget.getSmsCode(phone: phone))
            .result()
    }
    
    public func login(phone: String, password: String) -> Observable<LoadingSequence<OAuthToken>> {
        return apiService.makeRequest(to: AuthTarget.loginUser(phone: phone, password: password))
            .result(OAuthToken.self)
            .asLoadingSequence()
            .do(onNext: { [weak self] token in
                self?.updateToken(with: token.result?.element)
            })
    }
    
    public func createUser(phone: String, fullName: String, password: String, cityId: Int, promo: String?) -> Observable<LoadingSequence<OAuthToken>> {
        return apiService.makeRequest(
            to: AuthTarget.register(
                username: phone,
                password: password,
                fullName: fullName,
                cityId: cityId,
                promo: promo)
        )
        .result(OAuthToken.self).asLoadingSequence()
    }
    
    public func addLogoutListener(_ logoutListener: LogoutListener) {
        logoutListeners.append(logoutListener)
    }
    
    public func forceLogout() {
        updateToken(with: nil)
        logoutListeners.forEach { $0.cleanUpAfterLogout() }
    }
    
    public func updateToken(with newToken: OAuthToken?) {
        token = newToken
    }
}

public enum OAuthRefreshError: Error {
    case noRefreshToken
}
