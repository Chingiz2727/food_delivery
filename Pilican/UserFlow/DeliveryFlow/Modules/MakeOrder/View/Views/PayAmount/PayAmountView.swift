import UIKit

final class PayAmountView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .heading2
        label.textAlignment = .left
        label.text = "Цены в kzt, вкл. налоги"
        return label
    }()

    private let totalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .heading2
        label.textAlignment = .left
        label.text = "Всего"
        return label
    }()
    
    let costLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primary
        label.textAlignment = .left
        return label
    }()
    
    let payButton = PrimaryButton()
    
    let orderCost = PayValueView()
    let deliveryCost = PayValueView()
    let extraPayment = PayValueView()

    private lazy var stackView = UIStackView(
        views: [totalLabel, costLabel],
        axis: .vertical,
        spacing: 10)

    private lazy var horizontalStackView = UIStackView(
        views: [stackView, UIView(), payButton],
        axis: .horizontal,
        spacing: 30)

    private lazy var fullInfoStackView = UIStackView(
        views: [titleLabel, orderCost, deliveryCost, extraPayment, horizontalStackView],
        axis: .vertical,
        spacing: 3)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func setupOrderCost(cost: String) {
        orderCost.setup(title: "Сумма заказа")
        orderCost.setup(price: cost)
    }

    func setupDeliveryCost(cost: String) {
        deliveryCost.setup(title: "Доставка")
        deliveryCost.setup(price: cost)
    }

    func setupExtraCost() {
        extraPayment.isHidden = false
        extraPayment.setup(title: "Доплата до минимальной суммы заказа")
        extraPayment.setup(detail: "Минимальная сумма заказа - 2000 тенге. За заказы меньше этой сумма взимается дополнительная комиссия.")
        extraPayment.setup(price: "600 тг")
    }

    func setupFullCost(cost: Int) {
        costLabel.text = "\(cost) тг"
    }
    func clearExtraCost() {
        extraPayment.isHidden = true
    }

    private func setupInitialLayout() {
        addSubview(fullInfoStackView)
        fullInfoStackView.snp.makeConstraints { $0.edges.equalToSuperview().inset(10) }
        payButton.snp.makeConstraints { make in
            make.width.equalTo(160)
        }
        backgroundColor = .white
    }

    private func configureView() {
        payButton.setTitle("Оформить заказ", for: .normal)
        layer.cornerRadius = 10
    }
}
