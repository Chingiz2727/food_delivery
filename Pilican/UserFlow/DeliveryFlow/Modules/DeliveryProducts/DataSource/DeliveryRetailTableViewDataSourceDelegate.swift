import UIKit

final class DeliveryRetailTableViewDataSourceDelegate: NSObject, UITableViewDataSource {
    var productCategory: [ProductCategory] = []
    private let dishList: DishList

    init(dishList: DishList) {
        self.dishList = dishList
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return productCategory.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productCategory[section].dishes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: DeliveryRetailProductTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let product = productCategory[indexPath.section].dishes[indexPath.row]
        cell.buttonsLabel.addToDish = { [unowned self] product in
            self.productCategory[indexPath.section].dishes[indexPath.row] = self.dishList.changeDishList(dishAction: .addToDish(product))
            cell.setData(product: product)
            
        }
        
        cell.buttonsLabel.removeFromDish = { [unowned self] product in
            self.productCategory[indexPath.section].dishes[indexPath.row] = self.dishList.changeDishList(dishAction: .removeFromDish(product))
            cell.setData(product: product)
        }
        
        cell.setData(product: product)
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return productCategory[indexPath.section].dishes[indexPath.row].status == 2
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return productCategory[section].name
    }
}

extension DeliveryRetailTableViewDataSourceDelegate: UITableViewDelegate {
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cell = tableView.cellForRow(at: indexPath) as? DeliveryRetailProductTableViewCell
        
        let action = UIContextualAction(
            style: .normal,
            title: "") { [unowned self] _, _, completionHandler in
            let product = self.productCategory[indexPath.section].dishes[indexPath.row]
            let changedProduct = self.dishList.changeDishList(dishAction: .addToDish(product))
            self.productCategory[indexPath.section].dishes[indexPath.row] = changedProduct
            cell?.setData(product: changedProduct)
            completionHandler(true)
        }
        action.backgroundColor = .primary
        action.image = Images.accept.image?.withRenderingMode(.alwaysOriginal)
        return UISwipeActionsConfiguration(actions: [action])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let cell = tableView.cellForRow(at: indexPath) as? DeliveryRetailProductTableViewCell

        let action = UIContextualAction(
            style: .normal,
            title: "") { [unowned self] _, _, completionHandler in
            let product = self.productCategory[indexPath.section].dishes[indexPath.row]
            let changedProduct = self.dishList.changeDishList(dishAction: .removeFromDish(product))
            self.productCategory[indexPath.section].dishes[indexPath.row] = changedProduct
            cell?.setData(product: changedProduct)
            completionHandler(true)
        }
        
        action.backgroundColor = .red
        action.image = Images.decline.image?.withRenderingMode(.alwaysOriginal)
        
        return UISwipeActionsConfiguration(actions: [action])
    }
}
