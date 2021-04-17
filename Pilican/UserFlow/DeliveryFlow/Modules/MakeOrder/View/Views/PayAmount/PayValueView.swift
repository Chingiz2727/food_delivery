import UIKit

final class PayValueView: UIView {
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .heading2
        label.textAlignment = .left
        return label
    }()
    
    private let detailLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .heading2
        label.textAlignment = .left
        return label
    }()
    
    private let costLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primary
        label.textAlignment = .left
        return label
    }()
    
    private lazy var stackView = UIStackView(
        views: [titleLabel, detailLabel],
        axis: .vertical,
        spacing: 10)
    
    private lazy var horizontalStackView = UIStackView(
        views: [stackView, UIView(), costLabel],
        axis: .horizontal,
        distribution: .fillProportionally,
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
