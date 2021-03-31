import Cosmos
import UIKit

final class DeliveryRetailHeaderView: UIView {
    
    private let favButtonHeight: CGFloat = 30
    private let imageHeight: CGFloat = 20
    private let deliveryImageSize: CGFloat = 30
    
    private let companyNameLabel: UILabel = {
        let label = UILabel()
        label.font = .semibold16
        label.text = "Zhekas doner House"
        return label
    }()
    
    private let companyAdressLabel: UILabel = {
        let label = UILabel()
        label.text = "Макатаева 198/1"
        label.font = .medium12
        return label
    }()
    
    private let workTimeLabel: UILabel = {
        let label = UILabel()
        label.text = "Режим работы \n10:00 - 23:00"
        label.font = .regular2
        label.numberOfLines = 2
        return label
    }()
    
    private let favouriteButton: UIButton = {
        let button = UIButton()
        button.setImage(#imageLiteral(resourceName: "staricon"), for: .normal)
        return button
    }()
    
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [companyNameLabel, companyAdressLabel])
        stackView.distribution = .fill
        stackView.spacing = 2
        stackView.axis = .vertical
        return stackView
    }()
    
    private lazy var infoStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [labelStackView, workTimeLabel, UIView(), favouriteButton])
        stackView.spacing = 10
        stackView.axis = .horizontal
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .medium12
        label.textColor = .pilicanBlack
        label.text = "4.0"
        return label
    }()
    
    private let ratingView: CosmosView = {
        let view = CosmosView()
        view.rating = 4
        view.settings.fillMode = .half
        view.settings.emptyImage = #imageLiteral(resourceName: "star")
        view.settings.filledImage = #imageLiteral(resourceName: "fav_retail")
        view.isUserInteractionEnabled = false
        return view
    }()
    
    private let deliveryImage: UIImageView = {
        let image = UIImageView()
        image.image = #imageLiteral(resourceName: "Delivery")
        image.contentMode = .scaleAspectFit
        return image
    }()
    
    private let deliveryTitle: UILabel = {
        let label = UILabel()
        label.text = "Доставка \n30-60 мин"
        label.numberOfLines = 0
        label.font = .description3
        return label
    }()
    
    private lazy var deliveryStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [deliveryImage, deliveryTitle])
        stackView.spacing = 2
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var ratingStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ratingView, ratingLabel])
        stackView.spacing = 2
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()

    private lazy var bottomStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ratingStack, UIView(), deliveryStack])
        stackView.distribution = .fill
        stackView.axis = .horizontal
        stackView.spacing = 10
        return stackView
    }()

    lazy var fullStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [infoStackView, bottomStack])
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.distribution = .fill
        return stackView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
    }

    override func layoutSubviews() {
    }

    required init?(coder: NSCoder) {
        nil
    }

    func setData(retail: Retail) {
        companyNameLabel.text = retail.name
        companyAdressLabel.text = retail.address
        ratingLabel.text = "\(retail.rating )"
        ratingView.rating = retail.rating
    }

    private func setupInitialLayout() {
        addSubview(fullStackView)
        fullStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(20)
        }

        ratingView.snp.makeConstraints { make in
            make.height.equalTo(imageHeight)
            make.width.equalTo(80)
        }
        
        favouriteButton.setContentHuggingPriority(.required, for: .horizontal)
        backgroundColor = .background
    }
}
