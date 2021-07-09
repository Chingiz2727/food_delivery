import UIKit

final class DeliveryRetailTableViewDataSourceDelegate: NSObject, UITableViewDataSource {
    var productCategory: [ProductCategory] = []
    var selectedCellIndexPath: NSIndexPath?
    let selectedCellHeight: CGFloat = 300
    let unselectedCellHeight: CGFloat = 140
    
    private let dishList: DishList
    private let analytic = assembler.resolver.resolve(PillicanAnalyticManager.self)!
    
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
            let dishProduct = self.dishList.changeDishList(dishAction: .addToDish(product))
            self.getProductIndexAndSection(product: product) { index in
                self.productCategory[index.section].dishes[index.row] = dishProduct
            }
            self.analytic.log(.cafefood)
            cell.setData(product: product)
            tableView.reloadData()
        }
        
        cell.buttonsLabel.removeFromDish = { [unowned self] product in
            self.analytic.log(.deletefood)
            let dishProduct = self.dishList.changeDishList(dishAction: .removeFromDish(product))
            self.getProductIndexAndSection(product: product) { index in
                self.productCategory[index.section].dishes[index.row] = dishProduct
            }
            cell.setData(product: product)
            tableView.reloadData()

        }
        
        cell.setSelected(selected: product.isExpanded ?? false)
        cell.setData(product: product)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell: DeliveryRetailProductTableViewCell = tableView.dequeueReusableCell(for: indexPath)
        let expanded = productCategory[indexPath.section].dishes[indexPath.row].isExpanded
        
        if expanded == true {
            cell.setSelected(selected: false)
            productCategory[indexPath.section].dishes[indexPath.row].isExpanded = false
        } else {
            cell.setSelected(selected: true)
            productCategory[indexPath.section].dishes[indexPath.row].isExpanded = true
        }
        tableView.beginUpdates()
        tableView.endUpdates()
        tableView.reloadRows(at: [indexPath], with: .none)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let expanded = productCategory[indexPath.section].dishes[indexPath.row].isExpanded
        if expanded == true {
            return selectedCellHeight
        }
        return unselectedCellHeight
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return productCategory[indexPath.section].dishes[indexPath.row].status == 2
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        view.addSubview(label)
        label.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(10)
        }
        view.backgroundColor = #colorLiteral(red: 0.8549019608, green: 0.8549019608, blue: 0.8549019608, alpha: 1)
        label.font = .semibold20
        label.textColor = .black
        label.text = productCategory[section].name
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 44
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
    
    func getProductIndexAndSection(product: Product, completion: @escaping(IndexPath)->()) {
        for (section, category) in productCategory.enumerated() {
            for (row, dish) in category.dishes.enumerated() {
                if product.id == dish.id {
                    completion(IndexPath(row: row, section: section))
                }
            }
        }
    }
}
