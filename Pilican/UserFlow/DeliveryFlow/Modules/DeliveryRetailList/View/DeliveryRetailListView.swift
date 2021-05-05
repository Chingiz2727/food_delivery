import UIKit

final class DeliveryRetailListView: UIView {

    let tableView = UITableView()
    private var cardViews: [RetailCardView] = []
    lazy var panGesture = UIPanGestureRecognizer()
    let header = DeliveryRetailListHeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: 170))
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func setupInitialLayout() {
        addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalTo(safeAreaLayoutGuide) }
        tableView.tableHeaderView = header
    }

    private func configureView() {
        backgroundColor = .background
        tableView.registerClassForCell(DeliveryRetailListTableViewCell.self)
    }
}
