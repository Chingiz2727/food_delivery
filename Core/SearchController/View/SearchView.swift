import UIKit

public class SearchView: UIView {
    
    public let searchBar: SearchBar = {
        let searchBar = SearchBar()
        searchBar.backgroundColor = .pilicanWhite
        searchBar.placeholder = "Поиск..."
        return searchBar
    }()
    
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
    
    public let tableView: UITableView = {
        let tableView = UITableView()
        tableView.backgroundColor = .clear
        tableView.isHidden = true
        tableView.clipsToBounds = true
        tableView.keyboardDismissMode = .onDrag
        return tableView
    }()
        
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        configureView()
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
        addSubview(searchBar)
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview().inset(4)
        }
        
        addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(4)
            make.leading.trailing.equalToSuperview()
        }
        
        backgroundImageView.addSubview(blurEffectView)
        
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalTo(backgroundImageView.snp.top)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureView() {
        backgroundColor = .background
    }
}
