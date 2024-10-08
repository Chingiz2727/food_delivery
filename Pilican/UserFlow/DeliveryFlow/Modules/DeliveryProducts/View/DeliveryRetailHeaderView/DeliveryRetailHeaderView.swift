import Cosmos
import Kingfisher
import SnapKit
import UIKit

final class DeliveryRetailHeaderView: UIView {

    private let favButtonHeight: CGFloat = 30
    private let imageHeight: CGFloat = 20
    private let deliveryImageSize: CGFloat = 30
    var stickyHeaderrHeightConstraint: Constraint?
    var stickyHeaderRatingImageConstraint: Constraint?

    private let productImageView: UIImageView = {
        let image = UIImageView()
        image.contentMode = .scaleToFill
        return image
    }()

    private let companyNameLabel: UILabel = {
        let label = UILabel()
        label.font = .semibold16
        label.numberOfLines = 0
        return label
    }()

    private let companyAdressLabel: UILabel = {
        let label = UILabel()
        label.font = .book14
        label.numberOfLines = 0
        return label
    }()

    private let workTimeLabel: UILabel = {
        let label = UILabel()
        label.font = .book12
        label.textAlignment = .left
        label.numberOfLines = 2
        return label
    }()

    let favouriteButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.emptyStar.image, for: .normal)
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
        let stackView = UIStackView(arrangedSubviews: [labelStackView, workTimeLabel, favouriteButton])
        stackView.spacing = 1
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()

    private let ratingLabel: UILabel = {
        let label = UILabel()
        label.font = .medium12
        label.textColor = .pilicanBlack
        return label
    }()

    private let ratingView: CosmosView = {
        let view = CosmosView()
        view.settings.fillMode = .full
        view.settings.emptyImage = Images.emptyStar.image
        view.settings.filledImage = Images.filledStar.image
        view.isUserInteractionEnabled = false
        return view
    }()

    private let deliveryImage: UIImageView = {
        let image = UIImageView()
        image.image = Images.deliver.image
        image.contentMode = .scaleAspectFit
        return image
    }()

    private let deliveryTitle: UILabel = {
        let label = UILabel()
        label.text = "Доставка \n30-60 мин"
        label.numberOfLines = 0
        label.font = .book10
        return label
    }()

    private lazy var deliveryStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [deliveryImage, deliveryTitle])
        stackView.spacing = 4
        stackView.axis = .horizontal
        stackView.distribution = .fill
        return stackView
    }()

    private lazy var ratingStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [ratingView, ratingLabel])
        stackView.spacing = 10
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
        let stackView = UIStackView(arrangedSubviews: [productImageView, infoStackView, bottomStack])
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

    func setFavouriteButton(favourite: Bool) {
        let image = favourite == true ? Images.fillStar.image : Images.emptyStar.image
        favouriteButton.setImage(image, for: .normal)
    }

    func setData(retail: DeliveryRetail, rating: Double, workTime: String) {
        companyNameLabel.text = retail.name
        companyAdressLabel.text = retail.address
        ratingLabel.text = "\(rating)"
        ratingView.rating = rating
        workTimeLabel.text = "Режим работы \n\(workTime)"
        productImageView.kf.setImage(with: URL(string: retail.imgLogo ?? "")!)
    }

    private func setupInitialLayout() {
        addSubview(fullStackView)
        fullStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
        }

        ratingView.snp.makeConstraints { make in
        }

        productImageView.snp.makeConstraints { make in
            make.height.equalTo(180)
            make.width.equalToSuperview()
        }

        favouriteButton.setContentHuggingPriority(.required, for: .horizontal)
        backgroundColor = .background
    }
}
