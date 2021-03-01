protocol ProfileMenuModule: Presentable {
    typealias MenuDidSelect = (HomeProfileMenu) -> Void

    var menuDidSelect: MenuDidSelect? { get set }
}
