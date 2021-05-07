import UIKit

final class NameValueView: UIView {
    let nameLabel = UILabel()
    private let valueLabel = UILabel()

    private lazy var stackView = UIStackView(
        views: [nameLabel, UIView(), valueLabel],
        axis: .horizontal,
        distribution: .fillProportionally,
        spacing: 5)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitiaLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func setup(name: String, value: String) {
        nameLabel.text = name
        valueLabel.text = value
    }

    func setup(name: String) {
        nameLabel.text = name
    }

    func setup(value: String) {
        valueLabel.text = value
    }

    private func setupInitiaLayout() {
        addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    private func configureView() {
        nameLabel.textAlignment = .left
        valueLabel.textAlignment = .right
        nameLabel.font = .book16
        nameLabel.numberOfLines = 0
        valueLabel.numberOfLines = 0
        valueLabel.font = .semibold20
    }
}
