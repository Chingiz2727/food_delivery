import UIKit

final class DeliveryRetailListView: UIView {
    
    public let searchBar: SearchBar = {
        let searchBar = SearchBar()
        searchBar.backgroundColor = .pilicanWhite
        searchBar.placeholder = "Поиск..."
        return searchBar
    }()

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
        tableView.tableHeaderView = header
    }

    private func configureView() {
        backgroundColor = .background
        tableView.registerClassForCell(DeliveryRetailListTableViewCell.self)
    }
}
