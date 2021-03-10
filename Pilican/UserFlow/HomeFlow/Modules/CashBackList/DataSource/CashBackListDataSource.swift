import UIKit
import RxSwift
import RxDataSources

final class CashBackListDataSource: RxTableViewSectionedReloadDataSource<RetailSection> {

    init() {
        super.init(configureCell: { _, tableView, index, model  in
            let cell: CashBackListTableViewCell = tableView.dequeueReusableCell(for: index)
            cell.setRetail(retail: model)
            return cell
        })
    }
}
