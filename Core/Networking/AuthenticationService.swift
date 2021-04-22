import RxSwift
import RxRelay
import Foundation

public protocol AuthenticationService {
    var token: String? { get }
    var authenticated: Observable<Bool> { get }
    
    func getSMSCode(_ phone: String) -> Observable<LoadingSequence<ResponseStatus>>
    func login(phone: String, password: String) -> Observable<LoadingSequence<UserAuthResponse>>
    func createUser(phone: String, fullName: String, password: String, cityId: Int, promo: String?) ->  Observable<LoadingSequence<UserAuthResponse>>
    
    func getAuthSmsCode(_ phone: String) -> Observable<LoadingSequence<ResponseStatus>>
    func verifySmsCode(_ phone: String, code: String) -> Observable<LoadingSequence<UserAuthResponse>>
    func updateToken(with newToken: Token?)
    func updateProfile(with profile: UserAuthResponse?)
    func forceLogout()
}

public protocol LogoutListener {
    func cleanUpAfterLogout()
}

public final class AuthenticationServiceImpl: AuthenticationService {
    
    public var token: String?
    
    public var authenticated: Observable<Bool> {
        return authenticatedRelay.asObservable().distinctUntilChanged()
    }
    
    private var authenticatedRelay = BehaviorRelay(value: false)
    
    private let apiService: ApiService
    private let configService: ConfigService
    private let authTokenService: AuthTokenService
    public var sessionStorage: UserSessionStorage
    private let infoStorage: UserInfoStorage
    private var logoutListeners = [LogoutListener]()
    private let cache = DiskCache<String, Any>()
    
    init(
        apiService: ApiService,
        configService: ConfigService,
        authTokenService: AuthTokenService,
        sessionStorage: UserSessionStorage,
        infoStorage: UserInfoStorage
    ) {
        self.apiService = apiService
        self.configService = configService
        self.authTokenService = authTokenService
        self.infoStorage = infoStorage
        self.sessionStorage = sessionStorage
        token = sessionStorage.accessToken
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
            .do(onNext: { [weak self] result in
                guard let info = result.result?.element else { return }
                self?.updateToken(with: info.token)
                self?.updateProfile(with: info)
                self?.token = result.result?.element?.token.accessToken
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
        .do(onNext: { [weak self] result in
            guard let info = result.result?.element else { return }
            self?.updateToken(with: info.token)
            self?.updateProfile(with: info)
            
        })
    }
    
    public func getAuthSmsCode(_ phone: String) -> Observable<LoadingSequence<ResponseStatus>> {
        return apiService.makeRequest(to: AuthTarget.getAuthSmsCode(phone: phone))
            .result(ResponseStatus.self).asLoadingSequence()
    }
    
    public func verifySmsCode(_ phone: String, code: String) -> Observable<LoadingSequence<UserAuthResponse>> {
        return apiService.makeRequest(to: AuthTarget.verifySmsCode(phone: phone, code: code))
            .result(UserAuthResponse.self).asLoadingSequence()
            .do(onNext: { [weak self] res in
                guard let result = res.result?.element else { return }
                self?.updateToken(with: result.token)
                self?.updateProfile(with: result)
            })
    }
    
    public func addLogoutListener(_ logoutListener: LogoutListener) {
        logoutListeners.append(logoutListener)
    }
    
    public func forceLogout() {
        logoutListeners.forEach { $0.cleanUpAfterLogout() }
    }
    
    public func updateToken(with newToken: Token?) {
        sessionStorage.accessToken = newToken?.accessToken
        sessionStorage.refreshToken = newToken?.refreshToken
    }
    
    public func updateProfile(with profile: UserAuthResponse?) {
        infoStorage.fullName = profile?.profile.firstName
        infoStorage.balance = profile?.user.balance
        infoStorage.city = profile?.profile.city.name
        infoStorage.cityId = profile?.profile.city.id
        infoStorage.lastName = profile?.profile.lastName
        infoStorage.promoCode = profile?.user.promoCode
        infoStorage.mobilePhoneNumber = profile?.user.username
        infoStorage.birthday = profile?.profile.birthDay
        infoStorage.gender = profile?.profile.sex
        infoStorage.isCard = profile?.user.isCard
    }
    
}

public enum OAuthRefreshError: Error {
    case noRefreshToken
}
