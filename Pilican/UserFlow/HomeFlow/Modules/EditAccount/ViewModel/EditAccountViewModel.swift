//
//  EditAccountViewModel.swift
//  Pilican
//
//  Created by kairzhan on 3/12/21.
//

import RxSwift

final class EditAccountViewModel: ViewModel {
    
    struct Input {
        let saveTapped: Observable<Void>
        let username: Observable<String>
        let fullname: Observable<String?>
        let city: Observable<City>
        let gender: Observable<Gender>
        let birthday: Observable<String?>
        let loadCity: Observable<Void>
        let loadGender: Observable<Void>
    }

    struct Output {
        let updatedAccount: Observable<LoadingSequence<ResponseStatus>>
        let getCity: Observable<[City]>
        let getGender: Observable<[Gender]>
    }

    private let apiService: ApiService

    init(apiService: ApiService) {
        self.apiService = apiService
    }

    func transform(input: Input) -> Output {
        let updateAccount = input.saveTapped
            .withLatestFrom(
                Observable.combineLatest(
                    input.username,
                    input.fullname,
                    input.city,
                    input.birthday,
                    input.gender)
            ).flatMap { [unowned self] userName, fullName, city, birth, gender in
                return apiService.makeRequest(
                    to:
                        AuthTarget.updateProfile(
                        username: userName,
                            sex: "\(gender.id)",
                            fullName: fullName ?? "",
                        birthday: birth ?? "",
                        cityId: "\(city.id)"))
                    .result(ResponseStatus.self)
            }.asLoadingSequence()

        let loadCity = input.loadCity
            .flatMap { [unowned self] in
                return Observable.just(loadJson())
            }

        let loadGender = input.loadGender
            .flatMap {
                return Observable.just([Gender.init(id: 1, gender: "Мужчина"), Gender.init(id: 0, gender: "Женщина")])
            }

        return .init(updatedAccount: updateAccount, getCity: loadCity, getGender: loadGender)
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
