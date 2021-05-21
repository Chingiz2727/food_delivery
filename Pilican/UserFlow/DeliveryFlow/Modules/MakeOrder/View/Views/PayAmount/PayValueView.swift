import UIKit

final class PayValueView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .medium16
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    private let detailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .book12
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    let costLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primary
        label.textAlignment = .right
        return label
    }()

    private lazy var stackView = UIStackView(
        views: [titleLabel, detailLabel],
        axis: .vertical,
        spacing: 5)

    private lazy var horizontalStackView = UIStackView(
        views: [stackView, UIView(), costLabel],
        axis: .horizontal,
        distribution: .fillProportionally,
        alignment: .center,
        spacing: 10)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func setup(title: String) {
        titleLabel.text = title
    }

    func setup(price: String) {
        costLabel.text = price
    }

    func setup(detail: String) {
        detailLabel.text = detail
    }

    private func setupInitialLayout() {
        addSubview(stackView)
        addSubview(costLabel)
        stackView.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.trailing.equalTo(costLabel.snp.leading).offset(-40)
        }
        
        costLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalTo(100)
            make.trailing.equalToSuperview()
        }
    }
}
