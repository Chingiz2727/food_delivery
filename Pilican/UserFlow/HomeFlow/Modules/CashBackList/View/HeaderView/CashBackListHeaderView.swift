import RxSwift
import UIKit

private enum Constants {
    static let foodTitle = "Поесть"
    static let entertainmentTitle = "Развлечения"
    static let salesTitle = "Покупки"
    static let serviceTitle = "Услуги"
}

final class CashBackListHeaderView: UIView {

    private let mapImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = Images.mapBackground.image
        return imageView
    }()

    private let disposeBag = DisposeBag()
    let foodCategory = CategoryView()
    let entertainmentCategory = CategoryView()
    let salesCategory = CategoryView()
    let servicesCategory = CategoryView()

    private lazy var categoryStack = UIStackView(
        views: [foodCategory, entertainmentCategory, salesCategory, servicesCategory],
        axis: .horizontal,
        distribution: .equalSpacing,
        spacing: 10)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func setupInitialLayout() {
        addSubview(mapImageView)
        addSubview(categoryStack)

        mapImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(137)
        }

        categoryStack.snp.makeConstraints { make in
            make.top.equalTo(mapImageView.snp.bottom).offset(17)
            make.leading.trailing.equalToSuperview().inset(15)
            make.height.equalTo(75)
            make.bottom.equalToSuperview().inset(15)
        }

        categoryStack.arrangedSubviews.forEach { views in
            views.snp.makeConstraints { $0.size.equalTo(75) }
        }
    }

    private func configureView() {
        foodCategory.configureView(
            title: Constants.foodTitle,
            image: Images.knife.image,
            backColor: .pilicanWhite,
            titleColor: .pilicanBlack
        )
        entertainmentCategory.configureView(
            title: Constants.entertainmentTitle,
            image: Images.confetti.image,
            backColor: .pilicanWhite,
            titleColor: .pilicanBlack
        )
        salesCategory.configureView(
            title: Constants.salesTitle,
            image: Images.shoppingCart.image,
            backColor: .pilicanWhite,
            titleColor: .pilicanBlack
        )
        servicesCategory.configureView(
            title: Constants.serviceTitle,
            image: Images.girl.image,
            backColor: .pilicanWhite,
            titleColor: .pilicanBlack
        )

        backgroundColor = .background
    }
}
