import UIKit

final class DeliveryRetailListView: UIView {

    let tableView = UITableView()
    private var cardViews: [RetailCardView] = []
    lazy var panGesture = UIPanGestureRecognizer()

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
    }

    private func configureView() {
        backgroundColor = .background
        tableView.registerClassForCell(DeliveryRetailListTableViewCell.self)
    }
}
