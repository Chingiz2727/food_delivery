import PassKit
import UIKit

final class PayAmountView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .semibold20
        label.textAlignment = .left
        label.text = "Сумма к оплате"
        return label
    }()

    
    private let totalLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.font = .semibold18
        label.textAlignment = .left
        label.text = "Итого"
        return label
    }()

    let dividerLine = UIView()

    let costLabel: UILabel = {
        let label = UILabel()
        label.textColor = .primary
        label.textAlignment = .left
        return label
    }()

    let pkPaymentButton = PKPaymentButton(paymentButtonType: .buy, paymentButtonStyle: .black)
    
    let payButton = PrimaryButton()
    let orderCost = PayValueView()
    let deliveryCost = PayValueView()
    let extraPayment = PayValueView()

    private lazy var stackView = UIStackView(
        views: [totalLabel, costLabel],
        axis: .horizontal,
        spacing: 10)

    private lazy var horizontalStackView = UIStackView(
        views: [stackView, UIView(), payButton],
        axis: .vertical,
        distribution: .fillEqually)

    private lazy var fullInfoStackView = UIStackView(
        views: [titleLabel, orderCost, deliveryCost, extraPayment, UIView(), dividerLine, UIView(), stackView, UIView(), payButton, pkPaymentButton],
        axis: .vertical,
        spacing: 6)

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
        extraPayment.setup(detail: "Минимальная сумма заказа - 1500 тенге. За заказы меньше этой сумма взимается дополнительная комиссия.")
        extraPayment.setup(price: "600 〒")
    }

    func setupFullCost(cost: Int) {
        costLabel.text = "\(cost) 〒"
    }
    func clearExtraCost() {
        extraPayment.isHidden = true
    }

    private func setupInitialLayout() {
        addSubview(fullInfoStackView)
        fullInfoStackView.snp.makeConstraints { (make) in
            make.top.left.bottom.right.equalToSuperview().inset(10)
        }
        dividerLine.snp.makeConstraints { (make) in
            make.height.equalTo(1.5)
            make.left.right.equalToSuperview().inset(6)
        }
        payButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(6)
            make.height.equalTo(54)
        }
        
        pkPaymentButton.snp.makeConstraints { $0.height.equalTo(54) }
        backgroundColor = .white
    }

    private func configureView() {
        payButton.setTitle("Оплатить заказ", for: .normal)
        payButton.titleLabel?.font = .semibold18
        layer.cornerRadius = 10
        payButton.layer.cornerRadius = 12
        pkPaymentButton.layer.cornerRadius = 12
        dividerLine.backgroundColor = UIColor.pilicanLightGray.withAlphaComponent(0.5)
    }
}
