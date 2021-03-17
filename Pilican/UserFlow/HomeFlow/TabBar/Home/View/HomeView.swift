import UIKit

final class HomeView: UIView {
    let layout = CompaniesFlowLayout()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func setupInitialLayout() {
        addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalTo(safeAreaLayoutGuide).inset(10)
        }
        collectionView.collectionViewLayout = layout
    }

    private func configureView() {
        collectionView.backgroundColor = .grayBackground
        backgroundColor = .grayBackground
    }
}
