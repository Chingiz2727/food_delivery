import UIKit

public extension UITableView {

    typealias FooterContainer = UIView

    /// Sets layout sizing for view that will be assigned to tableFooterView
    func setSizedFooterView(_ view: FooterContainer) {
        let footerSize = view.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize,
            withHorizontalFittingPriority: .defaultHigh,
            verticalFittingPriority: .defaultLow
        )
        view.frame.size.height = footerSize.height
        tableFooterView = view
    }

    typealias HeaderContainer = UIView

    /// Sets layout sizing for view that will be assigned to tableHeaderView
    func setSizedHeaderView(_ view: FooterContainer) {

        let headerSize = view.systemLayoutSizeFitting(
            UIView.layoutFittingCompressedSize,
            withHorizontalFittingPriority: .defaultHigh,
            verticalFittingPriority: .defaultLow
        )
        view.frame.size.height = headerSize.height
        tableHeaderView = view
    }
}
