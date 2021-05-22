//
//  BalanceViewModel.swift
//  Pilican
//
//  Created by kairzhan on 4/20/21.
//

import RxSwift

final class BalanceViewModel: ViewModel {
    
    struct Input {
        let replenishTapped: Observable<Void>
        let amount: Observable<String>
    }

    struct Output {
        let result: Observable<LoadingSequence<BalanceResponse>>
    }
    
    private let userSessionStorage: UserSessionStorage
    private let apiService: ApiService

    init(apiService: ApiService, userSessionStorage: UserSessionStorage) {
        self.apiService = apiService
        self.userSessionStorage = userSessionStorage
    }

    func transform(input: Input) -> Output {
        let result = input.replenishTapped
            .withLatestFrom(input.amount)
            .flatMap { [unowned self] amount -> Observable<LoadingSequence<BalanceResponse>> in
                self.sendReplenish(amount: amount)
                    .asLoadingSequence()
            }.share()
        return .init(result: result)
    }
    
    func sendReplenish(amount: String) -> Observable<BalanceResponse> {
        return sendPaymentInfo(createdAt: String(String(NSDate().timeIntervalSince1970).split(separator: ".")[0]), amount: (amount as NSString).floatValue)
    }
    
    func sendPaymentInfo(createdAt: String, amount: Float) -> Observable<BalanceResponse>
    {
        let token = userSessionStorage.accessToken
        let newAccessToken = ((token! as NSString).substring(with: NSMakeRange(11, 21)) as NSString).substring(with: NSMakeRange(0, 10))
        let sig = ((newAccessToken + String(amount) + String(createdAt)).toBase64()).md5()
        return apiService.makeRequest(to: BalanceTarget.replenishBalance(sig: sig, amount: amount, createdAt: createdAt)).result(BalanceResponse.self)
    }

}

import Foundation

extension Decimal {
  public func floorDecimal() -> Decimal {
    return Decimal(floor(self.doubleValue))
  }
}

public extension Decimal {

  var doubleValue: Double {
    Double(truncating: self as NSNumber)
  }
}

public extension Decimal {
  var formattedStringWithCurrency: String {
    return (numberFormatter.string(for: self) ?? "")
  }

  var formattedRoundedString: String {
    return (numberFormatter.string(for: self) ?? "")
  }
}

private let numberFormatter: NumberFormatter = {
  let formatter = NumberFormatter()
  formatter.numberStyle = .decimal
  formatter.minimumFractionDigits = 0
  formatter.maximumFractionDigits = 2
  return formatter
}()

public extension String {
  var decimal: Decimal {
    return Decimal(string: self) ?? 0
  }
}
