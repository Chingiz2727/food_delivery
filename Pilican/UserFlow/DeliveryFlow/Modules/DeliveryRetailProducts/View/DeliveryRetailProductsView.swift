import SnapKit
import UIKit

final class DeliveryRetailProductsView: UIView {

    let tableView = UITableView()
    let segmentControl = ScrollabeSegmentControl()

    private let scrollView = UIScrollView()
    private var contentSizeObserver: NSKeyValueObservation?
    private var tableViewHeightConstraint: Constraint?
    private var stickyHeaderrHeightConstraint: Constraint?
    private let stickyHeaderView = UIView()
    
    private lazy var stackView = UIStackView(
        views: [stickyHeaderView, segmentControl, tableView],
        axis: .vertical,
        distribution: .fillProportionally,
        spacing: 10)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentSizeObserver = tableView.observe(
            \.contentSize,
            options: [.initial, .new]
        ) { [weak self] tableView, _ in
            self?.tableViewHeightConstraint?.update(offset: max(400, tableView.contentSize.height))
        }
        setupInitialLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func setTitles(titles: [String]) {
        segmentControl.set(titles: titles)
    }

    func setupHeader(point: CGFloat) {
        self.stickyHeaderrHeightConstraint?.update(offset: 300 - point)
    }

    func scrollSegmentToSection(section: Int) {
        segmentControl.colorAtIndex(index: section)
    }

    private func setupInitialLayout() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        stickyHeaderView.snp.makeConstraints { make in
            stickyHeaderrHeightConstraint = make.height.equalTo(300).constraint
        }

        tableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            tableViewHeightConstraint = make.height.equalTo(400).constraint
        }

        segmentControl.snp.makeConstraints { make in
            make.height.equalTo(40)
            make.width.equalToSuperview()
        }

        stickyHeaderrHeightConstraint?.activate()
        tableViewHeightConstraint?.activate()
    }

    private func configureView() {
        backgroundColor = .background
        tableView.bounces = true
        stickyHeaderView.backgroundColor = .blue
        tableView.registerClassForCell(DeliveryRetailProductTableViewCell.self)
    }
}

extension DeliveryRetailProductsView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentY = scrollView.contentOffset.y
        self.stickyHeaderrHeightConstraint?.update(offset: 300 - contentY)
    }
}
