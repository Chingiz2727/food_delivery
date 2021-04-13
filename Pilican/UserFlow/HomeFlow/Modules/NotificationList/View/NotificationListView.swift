import UIKit

final class NotificationListView: UIView {
    
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    func setupInitialLayouts() {
        addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
        
    }
    
    func configureView() {
        tableView.registerClassForCell(NotificationListTableViewCell.self)
        tableView.separatorInset = .init(top: 0, left: 0, bottom: 1, right: 0)
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .lightGray
        tableView.backgroundColor = .white
        tableView.tableFooterView = UIView()
    }
}
