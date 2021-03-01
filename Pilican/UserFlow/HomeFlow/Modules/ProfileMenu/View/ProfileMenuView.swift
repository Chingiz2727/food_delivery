import RxSwift
import UIKit
import SnapKit

final class ProfileMenuView: UIView {

    let tableView = UITableView()
    private var contentSizeObserver: NSKeyValueObservation?
    private var heightConstraint: Constraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        configureView()
        contentSizeObserver = tableView.observe(
            \.contentSize,
            options: [.initial, .new]
        ) { [weak self] tableView, _ in
            self?.heightConstraint?.update(offset: max(100, tableView.contentSize.height))
        }
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    private func setupInitialLayout() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            heightConstraint = make.height.equalTo(100).constraint
        }
        heightConstraint?.activate()
    }

    private func configureView() {
        backgroundColor = .pilicanWhite
        tableView.registerClassForCell(UITableViewCell.self)
        tableView.separatorStyle = .singleLine
        tableView.tableHeaderView = UIView()
        tableView.tableFooterView = UIView()
        tableView.bounces = false
    }
}
