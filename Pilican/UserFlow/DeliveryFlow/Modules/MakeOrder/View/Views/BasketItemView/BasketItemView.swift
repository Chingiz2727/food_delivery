import Kingfisher
import UIKit

final class BasketItemView: UIView {
    
    let clearButton: UIButton = {
        let button = UIButton()
        return button
    }()
    
    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 30
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let priceLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let countLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private let minusButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.minusDelivery.image, for: .normal)
        return button
    }()
    
    private let plusButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.plusDelivery.image, for: .normal)
        return button
    }()
    
    private lazy var buttonStackView = UIStackView(
        views: [minusButton, countLabel, plusButton],
        axis: .horizontal,
        distribution: .fillEqually,
        spacing: 14)
    
    private lazy var textStackView = UIStackView(
        views: [nameLabel, priceLabel],
        axis: .vertical,
        distribution: .fillEqually,
        spacing: 10)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    func setup(product: Product) {
        productImageView.kf.setImage(with: URL(string: product.imgLogo ?? ""))
        nameLabel.text = product.name
        priceLabel.text = "\(product.price) тг"
        countLabel.text = "\(product.shoppingCount ?? 0)"
    }
    
    private func setupInitialLayout() {
        addSubview(productImageView)
        addSubview(textStackView)
        addSubview(buttonStackView)
        
        productImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(14)
            make.size.equalTo(60)
            make.centerY.equalToSuperview()
        }
        
        textStackView.snp.makeConstraints { make in
            make.leading.equalTo(productImageView.snp.trailing).offset(10)
            make.top.bottom.equalToSuperview().inset(18)
            make.trailing.equalTo(buttonStackView.snp.trailing).offset(-10)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(14)
            make.height.equalTo(20)
        }
        
        [minusButton, plusButton].forEach { button in
            button.snp.makeConstraints { $0.size.equalTo(20) }
        }
    }
}
