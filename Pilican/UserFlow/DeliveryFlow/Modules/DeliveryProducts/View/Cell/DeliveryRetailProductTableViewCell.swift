import Kingfisher
import UIKit

class DeliveryRetailProductTableViewCell: UITableViewCell {
    private let backView = UIView()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .heading2
        label.textColor = .pilicanBlack
        label.numberOfLines = 0
        return label
    }()
    private let deliveryLine = UIView()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .book14
        label.textColor = .pilicanGray
        label.numberOfLines = 0
        return label
    }()

    private let productImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 8
        image.clipsToBounds = true
        return image
    }()

    let buttonsLabel = DeliveryButtonsView()
    var product: Product?
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
    
    private let secondImage: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [nameLabel, descriptionLabel, UIView(), priceStackView])
        stackView.distribution = .fill
        stackView.axis = .vertical
        stackView.spacing = 3
        return stackView
    }()
    
    
    private lazy var horizontalStack = UIStackView(views: [stackView, UIView(), productImage], axis: .horizontal, distribution: .fill, spacing: 10)
    
    private lazy var verticalStack = UIStackView(
        views: [secondImage,horizontalStack],
        axis: .vertical,
        distribution: .fill,
        spacing: 5)
    
    let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "Нет в наличии"
        label.textAlignment = .center
        label.font = .semibold24
        label.backgroundColor = .retailStatus
        label.isHidden = true
        label.layer.masksToBounds = true
        label.layer.zPosition = 1
        label.layer.cornerRadius = 5
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupInitialLayout()
        configureView()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setSelected(selected: Bool) {
        secondImage.isHidden = !selected
        productImage.isHidden = selected
        
    }
    
    func setData(product: Product) {
        self.product = product
        nameLabel.text = product.name
        descriptionLabel.text = product.composition
        buttonsLabel.setDish(companyDish: product)
        priceLabel.text = "\(product.price) 〒"
        deliveryLine.isHidden = product.shoppingCount ?? 0 == 0

        productImage.kf.setImage(with: URL(string: product.imgLogo ?? "")!)
        secondImage.kf.setImage(with: URL(string: product.imgLogo ?? "")!)
        if product.status == 1 {
            self.emptyLabel.isHidden = false
            self.isUserInteractionEnabled = false
        } else {
            self.emptyLabel.isHidden = true
            self.isUserInteractionEnabled = true
        }
    }

    private func setupInitialLayout() {
        backView.addSubview(emptyLabel)
        backView.addSubview(deliveryLine)

        emptyLabel.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        contentView.addSubview(backView)
        backView.snp.makeConstraints { $0.edges.equalToSuperview().inset(10) }
        backView.addSubview(verticalStack)
        verticalStack.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview().inset(5)
            make.leading.equalTo(deliveryLine.snp.trailing).offset(4)
        }
        productImage.snp.makeConstraints { make in
            make.size.equalTo(100)
        }
        deliveryLine.snp.makeConstraints { make in
            make.top.bottom.leading.equalToSuperview()
            make.width.equalTo(5)
        }
        secondImage.snp.makeConstraints { $0.height.equalTo(140) }
        verticalStack.sizeToFit()
        secondImage.isHidden = true
        deliveryLine.backgroundColor = .primary
        deliveryLine.isHidden = true
        selectionStyle = .none
    }

    private func configureView() {
        backgroundColor = .background
        backView.layer.cornerRadius = 10
        backView.backgroundColor = .white
    }

}
