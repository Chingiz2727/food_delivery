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
        label.font = .description2
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()
    
    let costLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primary
        label.textAlignment = .left
        return label
    }()
    
    private lazy var stackView = UIStackView(
        views: [titleLabel, detailLabel],
        axis: .vertical,
        spacing: 5)
    
    private lazy var horizontalStackView = UIStackView(
        views: [stackView, UIView(), costLabel],
        axis: .horizontal,
        distribution: .fill,
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
        addSubview(horizontalStackView)
        horizontalStackView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
