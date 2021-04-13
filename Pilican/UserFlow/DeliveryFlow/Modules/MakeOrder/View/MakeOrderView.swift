import YandexMapsMobile
import UIKit

final class MakeOrderView: UIView {
    let mapView = YMKMapView()
    
    private let deliveryView = DeliveryItemView()
    private let locationView = DeliveryItemView()
    private let maskEscapeView = DeliveryItemView()
    
    private let deliveryTitle: UILabel = {
        let label = UILabel()
        label.font = .heading1
        label.textAlignment = .left
        label.text = "Детали Заказа"
        return label
    }()
    
    private lazy var orderInfoStackView = UIStackView(
        views: [deliveryView, locationView, maskEscapeView],
        axis: .vertical,
        distribution: .fillEqually,
        spacing: 2)
    
    private let basketTitle: UILabel = {
        let label = UILabel()
        label.font = .heading1
        label.textAlignment = .left
        label.text = "Корзина"
        return label
    }()
    
    private lazy var baskerProductStack = UIStackView(
        views: [],
        axis: .vertical,
        spacing: 5)
    
    func setupProduct(products: [Product]) {
        products.forEach { product in
            let view = BasketItemView()
            view.setup(product: product)
            view.snp.makeConstraints { $0.height.equalTo(84) }
            baskerProductStack.addArrangedSubview(view)
        }
    }
}
