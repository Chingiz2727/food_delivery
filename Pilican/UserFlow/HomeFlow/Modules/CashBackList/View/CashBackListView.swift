import UIKit

final class CashBackListView: UIView {
    let layout = CompaniesFlowLayout()
    let tableView = UITableView()
    let headerView = CashBackListHeaderView()

    let footerView = PaginationTableFooterView()

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
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalTo(safeAreaLayoutGuide)
        }
    }

    private func configureView() {
        tableView.backgroundColor = .grayBackground
        backgroundColor = .grayBackground
    }
}
