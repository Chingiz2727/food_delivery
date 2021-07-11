import YandexMapsMobile
import SnapKit
import UIKit

final class MakeOrderView: UIView {
    let mapView = YMKMapView()
    let tableView = UITableView()
    let deliveryView = DeliveryItemView()
    let locationView = DeliveryItemView()
    let maskEscapeView = DeliveryItemView()
    private var contentSizeObserver: NSKeyValueObservation?
    private var heightConstraint: Constraint?

    private let deliveryTitle: UILabel = {
        let label = UILabel()
        label.font = .heading1
        label.textAlignment = .left
        label.text = "Детали заказа"
        return label
    }()

    let addressView = AdresssChoiceView()
    let bonusChoiceView = BonusChoiceView()
    private let deliveryOptionsView = UIView()
    private lazy var orderInfoStackView = UIStackView(
        views: [deliveryView, locationView, maskEscapeView],
        axis: .vertical,
        distribution: .fillProportionally,
        spacing: 10)

    private let basketTitle: UILabel = {
        let label = UILabel()
        label.font = .semibold24
        label.textAlignment = .left
        label.text = "Мой заказ"
        return label
    }()

    let payAmountView = PayAmountView()
    let commentView = MakeOrderCommentView()

    private lazy var stackView = UIStackView(
        views: [orderInfoStackView, basketTitle, tableView, commentView, deliveryOptionsView, payAmountView]
        ,axis: .vertical,
        spacing: 10)

    private lazy var secondStackView = UIStackView(
        views: [commentView, deliveryOptionsView, payAmountView]
        ,axis: .vertical,
        spacing: 10)

    private let scrollView = UIScrollView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        contentSizeObserver = tableView.observe(
            \.contentSize,
            options: [.initial, .new]
        ) { [weak self] tableView, _ in
            self?.heightConstraint?.update(offset: max(100, tableView.contentSize.height))
        }
        setupInitialLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func setupUserInfo(storage: UserInfoStorage) {
        bonusChoiceView.setData(cashback: "\(storage.balance ?? 0)")
    }

    private func setupInitialLayout() {
        addSubview(scrollView)

        scrollView.snp.makeConstraints { $0.edges.size.equalToSuperview() }
        scrollView.addSubview(mapView)
        scrollView.addSubview(stackView)
        scrollView.addSubview(tableView)
        scrollView.addSubview(secondStackView)
        mapView.snp.makeConstraints { make in
            make.top.width.leading.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        stackView.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(10)
            make.leading.width.trailing.equalToSuperview().inset(10)
        }
        tableView.snp.makeConstraints { make in
            make.top.equalTo(stackView.snp.bottom).offset(10)
            make.left.right.equalToSuperview().inset(10)
            heightConstraint = make.height.equalTo(100).constraint
        }
        secondStackView.snp.makeConstraints { make in
            make.top.equalTo(tableView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
        deliveryOptionsView.addSubview(addressView)
        deliveryOptionsView.addSubview(bonusChoiceView)
        addressView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
        }
        bonusChoiceView.snp.makeConstraints { make in
            make.top.equalTo(addressView.snp.bottom).offset(2)
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().inset(2)
        }

        heightConstraint?.activate()
    }

    func setupAmount(totalSum: Int, delivery: Int, orderType: OrderType) {
        if totalSum < 1499 {
            payAmountView.setupExtraCost()
            if orderType ==  .takeAway {
                payAmountView.setupFullCost(cost: totalSum + delivery)
            } else {
                payAmountView.setupFullCost(cost: totalSum + delivery + 600)
            }
        } else {
            payAmountView.clearExtraCost()
            payAmountView.setupFullCost(cost: totalSum + delivery)
        }
        payAmountView.setupDeliveryCost(cost: "\(delivery) 〒")
        payAmountView.setupOrderCost(cost: "\(totalSum) 〒")
    }

    func setupTakeAway() {
        locationView.isHidden = true
        payAmountView.deliveryCost.isHidden = true
    }

    func setOrderType(orderType: OrderType, address: String) {
        if orderType == .takeAway {
            maskEscapeView.isHidden = true
            deliveryView.setup(title: "Заберу навынос")
            deliveryView.setup(subTitle: "Заберу заказ самостоятельно")
            locationView.setup(title: "Адрес ресторана")
            locationView.isUserInteractionEnabled = false
            addressView.isUserInteractionEnabled = false
            addressView.titleLabel.text = "Адрес ресторана"
            deliveryView.setup(image: Images.man.image)
        }
    }

    private func configureView() {
        deliveryView.setup(title: "Доставка Pillikan", subTitle: "Доставка через 45 мин.", image: Images.pillikanDelivery.image)
        locationView.setup(title: "Адрес доставки", subTitle: "", image: Images.LocationSelected.image)
        maskEscapeView.setup(title: "Бесконтактная доставка", subTitle: "Пожалуйста, оставьте заказ возле двери/входа", image: Images.contactlessDellivery.image)
        maskEscapeView.uiControl.isHidden = true
        maskEscapeView.switchControl.isHidden = false
        backgroundColor =  .background
        deliveryOptionsView.backgroundColor = .white
        bonusChoiceView.backgroundColor = .white
        tableView.tableFooterView = UIView()
        bonusChoiceView.layer.cornerRadius = 10
        tableView.layer.cornerRadius = 10
        deliveryOptionsView.layer.cornerRadius = 10
        addressView.layer.cornerRadius = 10
        tableView.backgroundColor = .clear
        tableView.clipsToBounds = true
        tableView.registerClassForCell(BasketItemViewCell.self)
        clipsToBounds = true
        scrollView.clipsToBounds = true
    }
}
