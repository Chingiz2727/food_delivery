import RxSwift
import UIKit

final class ItemSearchViewMoodel: ViewModel {

    private let apiService: ApiService

    init(apiService: ApiService) {
        self.apiService = apiService
    }
    
    struct Input {
        let text: Observable<String>
        let loadTags: Observable<Void>
    }
    
    struct Output {
        let retailList: Observable<LoadingSequence<SearchList>>
        let tags: Observable<LoadingSequence<Tags>>
    }
    
    func transform(input: Input) -> Output {
        let retailList = input.text
            .flatMap { [unowned self] text in
                return self.apiService.makeRequest(to: SearchApiTarget.searchByTag(tag: text ?? ""))
                    .result(SearchList.self)
            }.share()
            .asLoadingSequence()
        let tags = input.loadTags
            .flatMap { [unowned self] in
                return self.apiService.makeRequest(to:SearchApiTarget.getTags)
                    .result(Tags.self)
            }.share().asLoadingSequence()
        return .init(retailList: retailList, tags: tags)
    }
}
