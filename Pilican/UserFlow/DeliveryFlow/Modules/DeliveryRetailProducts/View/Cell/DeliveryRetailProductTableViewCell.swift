import UIKit

class DeliveryRetailProductTableViewCell: SwipeableTableViewCell {
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .heading2
        label.textColor = .pilicanBlack
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .medium12
        label.textColor = .pilicanBlack
        label.numberOfLines = 0
        return label
    }()
    
    private let productImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 50
        return image
    }()
    
    let buttonsLabel = DeliveryButtonsView()
    
    private let  priceLabel: UILabel = {
        let label = UILabel()
        label.font = .medium16
        label.textColor = .pilicanBlack
        return label
    }()
    private var swipeView = UIView()
    
    private lazy var priceStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [buttonsLabel, priceLabel, UIView()])
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 5
        return stackView
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel, UIView(), priceStackView])
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 3
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupInitialLayout()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setData(product: Product) {
        nameLabel.text = product.name
        descriptionLabel.text = product.composition
        buttonsLabel.setDish(companyDish: product)
        priceLabel.text = "\(product.price)"
    }

    private func setupInitialLayout() {
        visibleContainerView.addSubview(stackView)
        visibleContainerView.addSubview(productImage)
        hiddenContainerView.addSubview(swipeView)
        swipeView.backgroundColor = .red
        stackView.snp.makeConstraints { make in
            make.leading.top.bottom.equalToSuperview().inset(10)
            make.trailing.equalTo(productImage.snp.leading).offset(10)
        }
        productImage.snp.makeConstraints { make in
            make.trailing.top.bottom.equalToSuperview().inset(10)
            make.size.equalTo(100)
        }
        
        swipeView.snp.makeConstraints { make in
            make.height.equalToSuperview()
            make.width.equalTo(50)
        }
        selectionStyle = .none
    }
}
