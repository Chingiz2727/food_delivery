protocol RetailSearchModule: Presentable, SearchContainerModule, BarButtonContainerModule {
    typealias OnSearchTap = (String) -> Void
    var onSearchTap: OnSearchTap? { get set }
}
