import UIKit
import SnapKit

final class DeliveryRetailListView: UIView {

    public let searchBar: SearchBar = {
        let searchBar = SearchBar()
        searchBar.backgroundColor = .pilicanWhite
        searchBar.placeholder = "Поиск..."
        return searchBar
    }()

    let tableView = UITableView()
    let searchTableView = UITableView()
    private var cardViews: [RetailCardView] = []
    lazy var panGesture = UIPanGestureRecognizer()
    let header = DeliveryRetailListHeaderView(frame: CGRect(x: 0, y: 0, width: 0, height: 170))
    let searchViewBack = UIView()
    private var contentSizeObserver: NSKeyValueObservation?
    private var heightConstraint: Constraint?

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        configureView()
        contentSizeObserver = searchTableView.observe(
            \.contentSize,
            options: [.initial, .new]
        ) { [weak self] collectionView, _ in
            self?.heightConstraint?.update(offset: max(40, collectionView.contentSize.height))
        }
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func setupInitialLayout() {
        addSubview(searchViewBack)
        searchViewBack.snp.makeConstraints { (make) in
            make.top.equalTo(safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }

        addSubview(searchBar)
        searchBar.snp.makeConstraints { (make) in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview().inset(5)
            make.height.equalTo(40)
        }

        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.bottom.equalToSuperview()
        }

        addSubview(searchTableView)
        searchTableView.snp.makeConstraints { (make) in
            make.top.equalTo(searchBar.snp.bottom)
            make.left.right.equalToSuperview()
            heightConstraint = make.height.equalTo(0).constraint
        }
        tableView.tableHeaderView = header
    }

    private func configureView() {
        backgroundColor = .background
        tableView.registerClassForCell(DeliveryRetailListTableViewCell.self)
        tableView.separatorStyle = .none
        searchViewBack.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        searchViewBack.isHidden = true
        searchTableView.isHidden = true
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        searchViewBack.isUserInteractionEnabled = true
        searchViewBack.addGestureRecognizer(gesture)
        searchTableView.backgroundColor = .clear
        searchTableView.separatorStyle = .none
    }

    @objc func dismissView() {
        searchTableView.isHidden = true
        searchViewBack.isHidden = true
    }
}
