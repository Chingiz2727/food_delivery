import RxSwift

final class RegistrationViewModel: ViewModel {

    struct Input {
        let registerTapped: Observable<Void>
        let getSmsTapped: Observable<Void>
        let loadCity: Observable<Void>
        let userLogin: Observable<String>
        let userName: Observable<String?>
        let promoCode: Observable<String?>
        let city: Observable<City>
        let smsCode: Observable<String?>
    }

    struct Output {
        let token: Observable<LoadingSequence<UserAuthResponse>>
        let getCity: Observable<[City]>
        let getSms: Observable<LoadingSequence<ResponseStatus>>
    }

    private let authService: AuthenticationService

    init(authService: AuthenticationService) {
        self.authService = authService
    }

    func transform(input: Input) -> Output {
        let registerUser = input.registerTapped
            .withLatestFrom(Observable.combineLatest(input.userLogin, input.userName, input.promoCode, input.city, input.smsCode))
            .flatMap { [unowned self] login, name, code, city, smsCode in
                authService.createUser(
                    phone: login,
                    fullName: name ?? "",
                    password: smsCode ?? "",
                    cityId: city.id,
                    promo: code ?? ""
                )
            }
            .share()

        let getSmsCode = input.getSmsTapped
            .withLatestFrom(input.userLogin)
            .flatMap { [unowned self] login in
                authService.getSMSCode(login)
            }
            .share()

        let loadCity = input.loadCity
            .flatMap { [unowned self]  in
                return Observable.just(loadJson())
            }

        return .init(token: registerUser, getCity: loadCity, getSms: getSmsCode)
    }

    private func loadJson() -> [City] {
        if let url = Bundle.main.url(forResource: "city", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let city = try decoder.decode(CityList.self, from: data)
                return city.cities
            } catch let error {
                print(error)
                return []
            }
        }
        return []
    }
}
