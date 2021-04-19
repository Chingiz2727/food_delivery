import Foundation
import RxSwift

private enum Constants {
    
    static let firstPage: Int = 0
}

public final class PaginationManager<Page: Pagination> {
    
    public typealias RequestFabric = (RequestParameters) -> Observable<Page>
    public typealias RequestParameters = (page: Int, count: Int, query: String)
    
    public var contentUpdate: Observable<[Page.Content]> {
        contentSubject.asObservable()
    }
    public var stateChange: Observable<PaginationState> {
        stateChangeSubject.asObservable()
    }
    
    public var isContentEmpty: Bool {
        return content.isEmpty
    }
    
    private let contentSubject = PublishSubject<[Page.Content]>()
    private let stateChangeSubject = PublishSubject<PaginationState>()
    
    private let requestFabric: RequestFabric
    private let pageSize: Int
    private let shouldLoadOnEmptyQuery: Bool
    
    public init(pageSize: Int = 15, shouldLoadOnEmptyQuery: Bool = true, requestFabric: @escaping RequestFabric) {
        self.requestFabric = requestFabric
        self.shouldLoadOnEmptyQuery = shouldLoadOnEmptyQuery
        self.pageSize = pageSize
    }
    
    private var content = [Page.Content]()
    
    // MARK: Content loading
    
    private var state: PaginationState = .idle {
        didSet {
            stateChangeSubject.onNext(state)
        }
    }
    
    private var hasContentToRequest: Bool = true
    
    private var page = Constants.firstPage
    
    private var query: String = ""
    private var hasNext: Bool = true
    private let disposeBag = DisposeBag()
    private var contentRequest: Disposable?
    private var maxElements = Int.max
    
    public func resetData() {
        contentRequest?.dispose()
        state = .idle
        page = Constants.firstPage
        content = []
        contentSubject.onNext(content)
        loadNextIfNeeded()
    }
    
    public func loadNextIfNeeded(retry: Bool = false) {
        if query.isEmpty && !shouldLoadOnEmptyQuery { return }
        guard hasContentToRequest else { return }
        guard state.isIdle || (state.isError && retry) else { return }
        
        state = .loading
        contentRequest = loadNext()
            .asSingle()
            .subscribe(
                onSuccess: { [weak self] newContent in
                    guard let self = self else { return }
                    self.content.append(contentsOf: newContent)
                    self.contentSubject.onNext(self.content)
                    self.state = .idle
                },
                onError: { [weak self] error in
                    self?.state = .error(error)
                }
            )
        
        contentRequest?.disposed(by: disposeBag)
    }
    
    private func loadNext() -> Observable<[Page.Content]> {
        guard hasContentToRequest else { return Observable.just([]) }
        
        let params = RequestParameters(page: page, count: pageSize, query: query)
        
        return requestFabric(params)
            .do(onNext: { [weak self] (pagination: Page) in
                self?.page += 1
                if let totalElements = pagination.totalElements {
                    self?.hasContentToRequest = totalElements > pagination.items.count
                }
                if let hasNext = pagination.hasNext {
                    self?.hasContentToRequest = hasNext
                }
            })
            .map { $0.items }
    }
    
    public func update(query: String) {
        self.query = query
        content = []
        contentSubject.onNext(content)
        if query.isEmpty && !shouldLoadOnEmptyQuery {
            state = .idle
        } else {
            state = .loading
        }
        contentRequest?.dispose()
    }
}

public extension PaginationManager where Page.Content: DateContent {
    
    var sectionContentUpdate: Observable<[DateSection<Page.Content>]> {
        contentUpdate.map {
            $0.reduce(into: [DateSection<Page.Content>]()) { result, value in
                guard let lastDate = result.last?.date else {
                    result.append(DateSection(date: value.sectionDate, content: [value]))
                    return
                }
                
                if Calendar.current.compare(lastDate, to: value.sectionDate, toGranularity: .day) == .orderedSame {
                    result[result.endIndex - 1].content.append(value)
                } else {
                    result.append(DateSection(date: value.sectionDate, content: [value]))
                }
            }
        }
    }
}

struct Dict: Hashable {
    let name: String
}
