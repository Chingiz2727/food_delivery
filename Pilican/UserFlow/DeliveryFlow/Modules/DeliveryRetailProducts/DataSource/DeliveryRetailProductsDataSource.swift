import UIKit
import RxSwift
import RxDataSources

final class DeliveryRetailProductDataSource: RxTableViewSectionedReloadDataSource<ProductCategory> {

    init() {
        super.init(configureCell: { _, tableView, index, model  in
            let cell: DeliveryRetailProductTableViewCell = tableView.dequeueReusableCell(for: index)
            cell.setData(product: model)
            return cell
        },
        titleForHeaderInSection: { category, index in
            return category.sectionModels[index].name
        })
    }
}
