import Foundation
import RxSwift

public final class IdPaginationManager<Page: IdPagination> {

  public typealias RequestFabric = (RequestParameters) -> Observable<Page>
  public typealias RequestParameters = (id: Page.IdType?, count: Int)

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

  public init(pageSize: Int = 20, requestFabric: @escaping RequestFabric) {
    self.requestFabric = requestFabric
    self.pageSize = pageSize
  }

  private var content = [Page.Content]()

  // MARK: Content loading

  private var state: PaginationState = .idle {
    didSet {
      stateChangeSubject.onNext(state)
    }
  }

  private var lastElementId: Page.IdType?
  private var hasContentToRequest: Bool = true

  private let disposeBag = DisposeBag()
  private var contentRequest: Disposable?

  public func resetData() {
    contentRequest?.dispose()
    state = .idle
    lastElementId = nil
    hasContentToRequest = true
    content = []
    contentSubject.onNext(content)
    loadNextIfNeeded()
  }

  public func loadNextIfNeeded(retry: Bool = false) {
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

    let params = RequestParameters(id: lastElementId, count: pageSize)

    return requestFabric(params)
      .do(onNext: { [weak self] (pagination: Page) in
        self?.lastElementId = pagination.lastElementId
        self?.hasContentToRequest = !pagination.isLast
      })
      .map { $0.items }
  }
}

public extension IdPaginationManager where Page.Content: DateContent {

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
