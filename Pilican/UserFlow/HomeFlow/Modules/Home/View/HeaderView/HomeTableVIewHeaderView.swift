import UIKit

class HomeTableVIewHeaderView: UIView {

    private let carouselView = ImageSlideshow()

    private lazy var categoryStack = UIStackView(
        views: [],
        axis: .horizontal,
        distribution: .fillEqually,
        alignment: .center,
        spacing: 10)

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.text = "Новые партнеры"
        return label
    }()

    private lazy var verticalStackView = UIStackView(
        views: [carouselView, categoryStack, titleLabel],
        axis: .vertical,
        spacing: 12)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func setupInitialLayout() {
        addSubview(verticalStackView)

        verticalStackView.snp.makeConstraints { $0.edges.equalToSuperview().inset(8) }

        carouselView.snp.makeConstraints { make in
            make.height.equalTo(130)
        }

        carouselView.backgroundColor = .red
        categoryStack.snp.makeConstraints { make in
            make.height.equalTo(40)
        }
    }
}
