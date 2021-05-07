import SnapKit
import UIKit

final class HomeView: UIView {
    let layout = CompaniesFlowLayout()
    let searchLayout = CompaniesFlowLayout()
    let searchBar: SearchBar = {
        let searchBar = SearchBar()
        searchBar.backgroundColor = .pilicanWhite
        searchBar.placeholder = "Поиск..."
        return searchBar
    }()
        
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let searchCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    private var contentSizeObserver: NSKeyValueObservation?
    private var heightConstraint: Constraint?
    let searchViewBack = UIView()
    
    private lazy var stackView = UIStackView(
        views: [searchBar, collectionView],
        axis: .vertical,
        distribution: .fill,
        spacing: 5)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentSizeObserver = searchCollectionView.observe(
            \.contentSize,
            options: [.initial, .new]
        ) { [weak self] collectionView, _ in
            self?.heightConstraint?.update(offset: max(40, collectionView.contentSize.height))
        }
        setupInitialLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func setupInitialLayout() {
        addSubview(collectionView)
        addSubview(searchViewBack)
        addSubview(searchBar)
        addSubview(searchCollectionView)

        searchCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(5)
            make.leading.trailing.equalToSuperview()
            heightConstraint = make.height.equalTo(0).constraint
        }

        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(50)
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).offset(10)
        }

        searchViewBack.snp.makeConstraints { $0.edges.equalToSuperview() }
        searchViewBack.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        searchViewBack.isHidden = true
        searchCollectionView.isHidden = true
        collectionView.collectionViewLayout = layout
        searchCollectionView.collectionViewLayout = searchLayout
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissView))
        searchViewBack.isUserInteractionEnabled = true
        searchViewBack.addGestureRecognizer(gesture)
    }

    @objc func dismissView() {
        searchCollectionView.isHidden = true
        searchViewBack.isHidden = true
    }
    private func configureView() {
        collectionView.backgroundColor = .grayBackground
        searchCollectionView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        backgroundColor = .grayBackground
        searchBar.layer.cornerRadius = 10
    }
}
