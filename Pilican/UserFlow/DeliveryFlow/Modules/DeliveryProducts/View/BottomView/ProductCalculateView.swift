import UIKit

final class ProductCalculateView: UIView {
    let control = UIControl()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.textAlignment = .left
        label.font = .medium21
        label.text = "Перейте к оплате"
        label.numberOfLines = 1
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.textColor = .white
        label.font = .medium21
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var stackView = UIStackView(
        views: [titleLabel, UIView(), priceLabel],
        axis: .horizontal,
        spacing: 10)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    func setupProductToCalculate(product: [Product]) {
        let amount = product.map { $0.price * ($0.shoppingCount ?? 0)}
        let totalSum = amount.reduce(0,+)
        priceLabel.text = "\(totalSum) Тг"
    }

    private func setupInitialLayout() {
        addSubview(stackView)
        addSubview(control)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview().inset(5) }
        control.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    private func configureView() {
        backgroundColor = .primary
    }
}
