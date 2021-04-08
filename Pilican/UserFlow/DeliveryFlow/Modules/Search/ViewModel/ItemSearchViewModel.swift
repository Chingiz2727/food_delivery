import RxSwift
import UIKit

final class ItemSearchViewMoodel: ViewModel {
    
    private let apiService: ApiService
    
    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    struct Input {
        let text: Observable<String>
    }
    
    struct Output {
        let retailList: Observable<LoadingSequence<SearchList>>
    }
    
    func transform(input: Input) -> Output {
        let retailList = input.text
            .flatMap { [unowned self] text in
                return self.apiService.makeRequest(to: SearchApiTarget.searchByTag(tag: text ?? ""))
                    .result(SearchList.self)
            }.share()
            .asLoadingSequence()
            
        return .init(retailList: retailList)
    }
}
