import SnapKit
import UIKit

final class DeliveryRetailProductsView: UIView {

    let tableView = UITableView()
    let segmentControl = ScrollabeSegmentControl()

    private let scrollView = UIScrollView()
    private var contentSizeObserver: NSKeyValueObservation?
    private var tableViewHeightConstraint: Constraint?
    private var stickyHeaderrHeightConstraint: Constraint?
    let calculateView = ProductCalculateView()
    let stickyHeaderView = DeliveryRetailHeaderView()
    var headerHeightConstraint: NSLayoutConstraint!
    var tableHeightConstraint: NSLayoutConstraint!

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

    func setRetail(retail: DeliveryRetail, calendar: WorkCalendar) {
        let currentTime = retail.workDays.filter { $0.day == calendar.currenDayNumber }.first
        let time = (currentTime?.timeStart ?? "") + " - " + (currentTime?.timeEnd ?? "")
        
        stickyHeaderView.setData(retail: retail, workTime: time)
    }
    
    func setTitles(titles: [String]) {
        segmentControl.set(titles: titles)
    }

    func setupHeader(point: CGFloat) {
        headerHeightConstraint.constant = 300 - point
        stickyHeaderView.stickyHeaderrHeightConstraint?.update(offset: 300 - point)
//        self.stickyHeaderrHeightConstraint?.update(offset: 300 - point)
    }

    func scrollSegmentToSection(section: Int) {
        segmentControl.colorAtIndex(index: section)
    }

    func setProductToPay(product: [Product]) {
        calculateView.isHidden = product.isEmpty
        calculateView.setupProductToCalculate(product: product)
    }

    private func setupInitialLayout() {
        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate(
            [
                stackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
                stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                stackView.topAnchor.constraint(equalTo: topAnchor)
            ]
        )

        stickyHeaderView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                stickyHeaderView.widthAnchor.constraint(equalTo: widthAnchor)
            ]
        )
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                tableView.widthAnchor.constraint(equalTo: widthAnchor),
            ]
        )
        
        segmentControl.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                segmentControl.heightAnchor.constraint(equalToConstant: 60),
                segmentControl.widthAnchor.constraint(equalTo: widthAnchor)
            ]
        )

        calculateView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(
            [
                calculateView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
                calculateView.heightAnchor.constraint(equalToConstant: 45)
            ]
        )
        
        tableHeightConstraint = tableView.heightAnchor.constraint(equalToConstant: 400)
        tableHeightConstraint?.isActive = true
        headerHeightConstraint = stickyHeaderView.heightAnchor.constraint(equalToConstant: 300)
        headerHeightConstraint.isActive = true
    }

    private func configureView() {
        backgroundColor = .background
        tableView.separatorStyle = .none
        tableView.bounces = true
        tableView.tableHeaderView = ProductsHeaderView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 100))
        segmentControl.backgroundColor = .background
        stackView.backgroundColor = .background
        calculateView.isHidden = true
        tableView.registerClassForCell(DeliveryRetailProductTableViewCell.self)
    }

    func hideHeaderView(contentY: CGFloat) {
//        UIView.animate(withDuration: 1.6, delay: 0, usingSpringWithDamping: 0, initialSpringVelocity: 0, options: .curveEaseIn) {
//            self.stickyHeaderView.isHidden = 300 - contentY < 0
//        }
    }
}

extension DeliveryRetailProductsView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentY = scrollView.contentOffset.y
//        self.hideHeaderView(contentY: 300 - contentY)
        self.stickyHeaderrHeightConstraint?.update(offset: 300 - contentY)
    }
}
