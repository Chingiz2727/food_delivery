import UIKit
import SnapKit
import RxSwift

public class SearchView: UIView {
    
    let scrollView = UIScrollView()
    
    public let searchBar: SearchBar = {
        let searchBar = SearchBar()
        searchBar.backgroundColor = .pilicanWhite
        searchBar.placeholder = "Поиск еды и ресторанов"
        searchBar.returnKeyType = .done
        searchBar.addDoneOnKeyboardWithTarget(nil, action: #selector(dismissKeyboard), titleText: "Поиск еды и ресторанов")
        
        return searchBar
    }()
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
    
    public let backgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .primary
        return imageView
    }()
    
    public let blurEffectView: UIView = {
        let effect = UIBlurEffect(style: .light)
        let effectView = UIVisualEffectView(effect: effect)
        effectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        effectView.alpha = 0.7
        return effectView
    }()
    
    let searchTagsView = SearchTagsView()
    
    lazy var stackView = UIStackView(
        views: [searchBar, searchTagsView, tableView],
        axis: .vertical,
        distribution: .fill,
        spacing: 0)
    
    public let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.isHidden = true
        tableView.clipsToBounds = true
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
    private var contentSizeObserver: NSKeyValueObservation?
    private var heightConstraint: Constraint?
        
    public override init(frame: CGRect) {
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
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        backgroundImageView.layer.cornerRadius = 8
        blurEffectView.bounds = backgroundImageView.bounds
        tableView.layer.cornerRadius = 8
    }
    
    private func setupInitialLayout() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalTo(safeAreaLayoutGuide)
        }

        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { (make) in
            make.edges.width.equalToSuperview()
        }

        searchTagsView.snp.makeConstraints { (make) in
            make.height.equalTo(220)
        }

        tableView.snp.makeConstraints { make in
            heightConstraint = make.height.equalTo(100).constraint
        }

        heightConstraint?.activate()
    }
    
    private func configureView() {
        backgroundColor = .background
        tableView.separatorStyle = .none
        tableView.bounces = false
    }
}
