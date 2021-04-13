import RxSwift
import UIKit

final class PillikanPayView: UIView {
    
    let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
        configureView()
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
        tableView.tableFooterView = UIView()
        backgroundColor = .grayBackground
    }
    
}
