import RxSwift
import Kingfisher
import UIKit

private enum Constants {
    static let cashBackTitle = "Cashback"
    static let busTitle = "Автобус"
    static let deliveryTitle = "Доставка"
    static let volunteerTitle = "Volunteer"
}

final class HomeCollectionViewHeaderView: UICollectionReusableView {

    private let carouselView = ImageSlideshow()
    private(set) var disposeBag = DisposeBag()

    private lazy var categoryStack = UIStackView(
        views: [cashBackCategory, busCategory, deliveryCategory, volunteerCategory],
        axis: .horizontal,
        distribution: .equalSpacing,
        spacing: 10)

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .heading2
        label.text = "Новые партнеры"
        return label
    }()

    private lazy var verticalStackView = UIStackView(
        views: [carouselView, categoryStack, titleLabel],
        axis: .vertical,
        spacing: 12)

    let selectedTag = PublishSubject<Int>()

    private let cashBackCategory = CategoryView()
    private let busCategory = CategoryView()
    private let deliveryCategory = CategoryView()
    private let volunteerCategory = CategoryView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupGradient()
        setupInitialLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func setupSlider(sliders: [Slider]) {
//        carouselView.setImageInputs( sliders.map { KingfisherSource(url: URL(string: $0.imgLogo )!) })
    }

    private func setupInitialLayout() {
        addSubview(verticalStackView)

        verticalStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(16)
            make.top.bottom.equalToSuperview().inset(8)
        }

        carouselView.snp.makeConstraints { make in
            make.height.equalTo(130)
        }

        [cashBackCategory, busCategory, deliveryCategory, volunteerCategory].forEach { view in
            view.snp.makeConstraints { $0.size.equalTo(80) }
        }
    }

    private func configureView() {
        carouselView.circular = true
        carouselView.slideshowInterval = 3
        carouselView.contentScaleMode = .scaleAspectFill
        carouselView.layer.cornerRadius = 10
        cashBackCategory.configureView(
            title: Constants.cashBackTitle,
            image: Images.cashbackgroup.image,
            backColor: .primary, titleColor: .pilicanWhite
        )
        busCategory.configureView(
            title: Constants.busTitle,
            image: Images.bus.image,
            backColor: .green,
            titleColor: .pilicanWhite
        )
        deliveryCategory.configureView(
            title: Constants.deliveryTitle,
            image: Images.breaking.image,
            backColor: .error,
            titleColor: .pilicanWhite
        )
        volunteerCategory.configureView(
            title: Constants.volunteerTitle,
            image: Images.group.image,
            backColor: .cyan,
            titleColor: .pilicanWhite
        )
        cashBackCategory.tag = 0
        busCategory.tag = 1
        deliveryCategory.tag = 2
        volunteerCategory.tag = 3

        [cashBackCategory, busCategory, deliveryCategory, volunteerCategory].forEach { control in
            control.control.rx.controlEvent(.touchUpInside)
                .subscribe(
                    onNext: { [unowned self] in
                        self.selectedTag.onNext(control.tag)
                    }
                )
                .disposed(by: disposeBag)
        }
    }

    private func setupGradient() {
        let cashBackGradient: CAGradientLayer = .primaryGradient
        cashBackGradient.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        cashBackCategory.layer.insertSublayer(cashBackGradient, at: 0)
        let busBackGradient: CAGradientLayer = .greenGradient
        busBackGradient.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        busCategory.layer.insertSublayer(busBackGradient, at: 0)
        let deliveryBackGradient: CAGradientLayer = .redGradient
        deliveryBackGradient.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        deliveryCategory.layer.insertSublayer(deliveryBackGradient, at: 0)
        let volunteerBackGradient: CAGradientLayer = .blueGradient
        volunteerBackGradient.frame = CGRect(x: 0, y: 0, width: 80, height: 80)
        volunteerCategory.layer.insertSublayer(volunteerBackGradient, at: 0)
    }
}
