import SnapKit
import UIKit

final class DeliveryRetailProductsView: UIView {

    let tableView = UITableView()
    let segmentControl = ScrollabeSegmentControl()

    private let scrollView = UIScrollView()
    private var contentSizeObserver: NSKeyValueObservation?
    private var tableViewHeightConstraint: Constraint?
    private var stickyHeaderrHeightConstraint: Constraint?
    private let stickyHeaderView = DeliveryRetailHeaderView()
    private let calculateView = ProductCalculateView()
    private lazy var stackView = UIStackView(
        views: [stickyHeaderView, segmentControl, tableView, calculateView],
        axis: .vertical,
        distribution: .fill,
        spacing: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func setRetail(retail: DeliveryRetail) {
        stickyHeaderView.setData(retail: retail)
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

    func setProductToPay(product: [Product]) {
        calculateView.isHidden = product.isEmpty == 0
        calculateView.setupProductToCalculate(product: product)
    }
    
    private func setupInitialLayout() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.top.bottom.equalTo(safeAreaLayoutGuide)
            make.leading.trailing.equalToSuperview()
        }

        stickyHeaderView.snp.makeConstraints { make in
            stickyHeaderrHeightConstraint = make.height.equalTo(300).constraint
        }

        tableView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            tableViewHeightConstraint = make.height.equalTo(400).constraint
        }

        segmentControl.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.width.equalToSuperview()
        }
        
        calculateView.snp.makeConstraints { $0.height.equalTo(45) }
        
        stickyHeaderrHeightConstraint?.activate()
    }

    private func configureView() {
        backgroundColor = .background
        tableView.separatorStyle = .none
        tableView.bounces = true
        segmentControl.backgroundColor = .background
        stackView.backgroundColor = .background
        calculateView.isHidden = true
        tableView.registerClassForCell(DeliveryRetailProductTableViewCell.self)
    }
}

extension DeliveryRetailProductsView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentY = scrollView.contentOffset.y
        self.stickyHeaderrHeightConstraint?.update(offset: 300 - contentY)
    }
}
