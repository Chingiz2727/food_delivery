import UIKit

final class OrderStatusView: UIView {
    private let onFetchingStatus = OrderProgressView()
    private let onPreparingStatus = OrderProgressView()
    private let onDeliveryStatus = OrderProgressView()
    private let finishedStatus = OrderProgressView()
    private let productTitle = NameValueView()
    private let productAmountValueView = NameValueView()
    private let deliveryValueView = NameValueView()
    private let extraValueView = NameValueView()
    private let totalValueView = NameValueView()
    private lazy var statusStack = UIStackView(
        views: [onFetchingStatus, onPreparingStatus, onDeliveryStatus, finishedStatus],
        axis: .vertical,
        distribution: .fillEqually,
        spacing: 0)

    private lazy var productStackView = UIStackView(
    views: [],
    axis: .vertical,
    distribution: .fillEqually,
    spacing: 4)

    private let productsTitle: UILabel = {
        let label = UILabel()
        label.font = .semibold24
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()

    private let title: UILabel = {
        let label = UILabel()
        label.font = .semibold24
        label.textAlignment = .left
        label.text = "Ваш заказ"
        return label
    }()

    private let sum: UILabel = {
        let label = UILabel()
        label.font = .semibold24
        label.textAlignment = .left
        label.text = "Сумма к оплате"
        return label
    }()

    private let dividerLine = UIView()

    private lazy var fullStackView = UIStackView(
        views: [productsTitle, UIView(), UIView(), statusStack, UIView(), title, productStackView, sum, productAmountValueView, deliveryValueView, extraValueView, dividerLine, totalValueView],
        axis: .vertical,
        spacing: 5)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func setData(response: DeliveryOrderResponse) {
        if let status = response.status {
            setStatus(status: OrderStatus(rawValue: status)!)
        }
        if let items = response.orderItems {
            setupOrderItems(items: items)
        }
        productsTitle.text = response.retailName
        productAmountValueView.setup(name: "Сумма заказа", value: "\(response.foodAmount ?? 0) 〒")
        deliveryValueView.setup(name: "Доставка", value: "\(response.deliveryAmount ?? 0) 〒")
        extraValueView.setup(name: "Доплата до минимальной суммы", value: "\(response.addAmount ?? 0) 〒")
        let full = (response.foodAmount ?? 0) + (response.deliveryAmount ?? 0) + (response.addAmount ?? 0)
        totalValueView.setup(name: "Итого", value: "\(full ?? 0) 〒")
    }

    private func setStatus(status: OrderStatus) {
        let statusList = OrderStatus.allCases
        let statusViewList = [onFetchingStatus, onPreparingStatus, onDeliveryStatus, finishedStatus]

        for (index, value) in statusViewList.enumerated() {
            if index == status.rawValue - 2 {
                value.setupStatus(status: statusList[index], passStatus: .onProgress)
            }
            if index > status.rawValue - 2 {
                value.setupStatus(status: statusList[index], passStatus: .disabled)
            }
            if index <= status.rawValue - 2 {
                value.setupStatus(status: statusList[index], passStatus: .onPassed)
            }
        }

        if statusList.count == status.rawValue - 1 {
            statusViewList.last?.setupStatus(status: .finished, passStatus: .onPassed)
        }
    }

    private func setupOrderItems(items: [OrderItems]) {
        items.forEach { [unowned self] product in
            let productView = OrderStatusProductView()
            productView.setup(with: product)
            productView.snp.makeConstraints { $0.height.equalTo(100) }
            self.productStackView.addArrangedSubview(productView)
            productView.backgroundColor = .pilicanWhite
        }
    }

    private func setupInitialLayout() {
        let scrollView = UIScrollView()
        addSubview(scrollView)
        scrollView.snp.makeConstraints { $0.edges.equalToSuperview() }
        scrollView.addSubview(fullStackView)
        fullStackView.snp.makeConstraints { make in
            make.leading.trailing.equalTo(self).inset(20)
            make.top.bottom.equalToSuperview().inset(20)
        }

        [onFetchingStatus, onPreparingStatus, onDeliveryStatus, finishedStatus].forEach { view in
            view.snp.makeConstraints { $0.height.equalTo(65) }
        }
        dividerLine.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.height.equalTo(1)
        }
        backgroundColor = .background
        productStackView.backgroundColor = .pilicanWhite
        dividerLine.backgroundColor = .pilicanGray
        totalValueView.nameLabel.font = .semibold18
    }
}
