import RxSwift
import Kingfisher
import UIKit

final class BasketItemViewCell: UITableViewCell {
    var removeProduct: ((Product) -> ())?
    var addProduct: ((Product?) -> ())?
    var product: Product?
    let disposeBag = DisposeBag()
    let clearButton: UIButton = {
        let button = UIButton()
        return button
    }()

    private let productImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        return imageView
    }()

    private let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .semibold16
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.font = .semibold16
        return label
    }()

    private let countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        return label
    }()

    let minusButton: UIButton = {
        let button = UIButton()
        button.tag = 1
        button.setImage(Images.minusDelivery.image, for: .normal)
        return button
    }()

    let plusButton: UIButton = {
        let button = UIButton()
        button.tag = 0
        button.setImage(Images.plusDelivery.image, for: .normal)
        return button
    }()

    private lazy var buttonStackView = UIStackView(
        views: [minusButton, countLabel, plusButton],
        axis: .horizontal,
        distribution: .fillEqually,
        spacing: 5)

    private lazy var textStackView = UIStackView(
        views: [nameLabel, priceLabel],
        axis: .vertical,
        distribution: .fillEqually,
        spacing: 10)

    private let dataView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupInitialLayout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func layoutSubviews() {
        layer.cornerRadius = 10
    }

    func setup(product: Product) {
        self.product = product
        productImageView.kf.setImage(with: URL(string: product.imgLogo ?? ""))
        nameLabel.text = product.name
        priceLabel.text = "\(product.price) 〒"
        countLabel.text = "\(product.shoppingCount ?? 0)"
    }

    private func setupInitialLayout() {
        addSubview(dataView)
        dataView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview().inset(1)
        }

        dataView.addSubview(productImageView)
        dataView.addSubview(textStackView)
        dataView.addSubview(buttonStackView)

        productImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.size.equalTo(60)
            make.centerY.equalToSuperview()
        }

        textStackView.snp.makeConstraints { make in
            make.leading.equalTo(productImageView.snp.trailing).offset(10)
            make.top.bottom.equalToSuperview().inset(18)
            make.trailing.equalToSuperview().inset(86)
        }

        buttonStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
            make.height.equalTo(40)
            make.top.bottom.equalToSuperview().inset(18)
        }

        countLabel.snp.makeConstraints { (make) in
            make.width.equalTo(20)
        }

        [minusButton, plusButton].forEach { button in
            button.snp.makeConstraints { $0.size.equalTo(20) }
        }
        minusButton.addTarget(self, action: #selector(setProduct), for: .touchUpInside)
        plusButton.addTarget(self, action: #selector(setProduct), for: .touchUpInside)
        buttonStackView.isUserInteractionEnabled = true
        selectionStyle = .none
        backgroundColor = .clear
        dataView.backgroundColor = .pilicanWhite
        dataView.layer.cornerRadius = 10
    }

    @objc private func setProduct(button: UIButton) {
        guard var product = product else { return }
        switch button.tag {
        case 0:
            product.shoppingCount! += 1
            self.addProduct?(product)
        case 1:
            product.shoppingCount! -= 1
            self.removeProduct?(product)
        default:
            break
        }
    }
}
