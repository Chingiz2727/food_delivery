import UIKit

final class PillikanInfoNotificationsView: UIView {
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setupInitialLayouts()
        
    }
    required init?(coder: NSCoder) {
        nil
    }
    
    private func setupInitialLayouts() {
        addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func configureView() {
        tableView.registerClassForCell(PillikanNotificationTableViewCell.self)
        tableView.separatorStyle = .none
        let footer = UIView()
        footer.backgroundColor = .grayBackground
        tableView.tableFooterView = footer
        tableView.backgroundColor = .grayBackground
        backgroundColor = .grayBackground
    }
}

