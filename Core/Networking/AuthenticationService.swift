import RxSwift
import RxRelay
import Foundation

public protocol AuthenticationService {
    var token: Token! { get }
    var authenticated: Observable<Bool> { get }
    
    func getSMSCode(_ phone: String) -> Observable<LoadingSequence<ResponseStatus>>
    func login(phone: String, password: String) -> Observable<LoadingSequence<UserAuthResponse>>
    func createUser(phone: String, fullName: String, password: String, cityId: Int, promo: String?) ->  Observable<LoadingSequence<UserAuthResponse>>
    
    func getAuthSmsCode(_ phone: String) -> Observable<LoadingSequence<ResponseStatus>>
    func verifySmsCode(_ phone: String, code: String) -> Observable<LoadingSequence<UserAuthResponse>>
}

public protocol LogoutListener {
    func cleanUpAfterLogout()
}

public final class AuthenticationServiceImpl: AuthenticationService {
    
    public var token: Token! {
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
    
    public func getSMSCode(_ phone: String) -> Observable<LoadingSequence<ResponseStatus>> {
        return apiService.makeRequest(to: AuthTarget.getSmsCode(phone: phone))
            .result()
            .asLoadingSequence()
    }
    
    public func login(phone: String, password: String) -> Observable<LoadingSequence<UserAuthResponse>> {
        return apiService.makeRequest(to: AuthTarget.loginUser(phone: phone, password: password))
            .result(UserAuthResponse.self)
            .asLoadingSequence()
            .do(onNext: { [weak self] token in
                guard let token = token.result?.element?.token else { return }
                self?.updateToken(with: nil)
                self?.updateToken(with: token)
            })
    }
    
    public func createUser(phone: String, fullName: String, password: String, cityId: Int, promo: String?) -> Observable<LoadingSequence<UserAuthResponse>> {
        return apiService.makeRequest(
            to: AuthTarget.register(
                username: phone,
                password: password,
                fullName: fullName,
                cityId: cityId,
                promo: promo)
        )
        .result(UserAuthResponse.self).asLoadingSequence()
        .do(onNext: { [weak self] token in
            guard let token = token.result?.element?.token else { return }
            self?.updateToken(with: nil)
            self?.updateToken(with: token)
        })
    }
    
    public func getAuthSmsCode(_ phone: String) -> Observable<LoadingSequence<ResponseStatus>> {
        return apiService.makeRequest(to: AuthTarget.getAuthSmsCode(phone: phone))
            .result(ResponseStatus.self).asLoadingSequence()
    }
    
    public func verifySmsCode(_ phone: String, code: String) -> Observable<LoadingSequence<UserAuthResponse>> {
        return apiService.makeRequest(to: AuthTarget.verifySmsCode(phone: phone, code: code))
            .result(UserAuthResponse.self).asLoadingSequence()
            .do(onNext: { [weak self] token in
                guard let token = token.result?.element?.token else { return }
                self?.updateToken(with: nil)
                self?.updateToken(with: token)
            })
    }

    public func addLogoutListener(_ logoutListener: LogoutListener) {
        logoutListeners.append(logoutListener)
    }
    
    public func forceLogout() {
        updateToken(with: nil)
        logoutListeners.forEach { $0.cleanUpAfterLogout() }
    }
    
    public func updateToken(with newToken: Token?) {
        token = newToken
    }
}

public enum OAuthRefreshError: Error {
    case noRefreshToken
}
