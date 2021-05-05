import RxSwift
import Kingfisher
import UIKit

private enum Constants {
    static let cashBackTitle = "Pillikan QR"
    static let busTitle = "Автобус"
    static let deliveryTitle = "Доставка"
    static let volunteerTitle = "Volunteer"
}

final class HomeCollectionViewHeaderView: UICollectionReusableView {

    private let carouselView = ImageSlideshow()
    private(set) var disposeBag = DisposeBag()
    var showTag: ((Int)->Void)?
    
    var didSelectTag: [UIControl: Int] = [:]
    
    private lazy var categoryStack = UIStackView(
        views: [cashBackCategory, busCategory, deliveryCategory, taxiCategory],
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
    let taxiCategory = TaxiView()

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
        carouselView.setImageInputs( sliders.map { KingfisherSource(url: URL(string: $0.imgLogo )!) })
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

        [cashBackCategory, busCategory, deliveryCategory, taxiCategory].forEach { view in
            view.snp.makeConstraints { $0.size.equalTo(75) }
        }
    }

    private func configureView() {
        carouselView.circular = true
        carouselView.slideshowInterval = 3
        carouselView.contentScaleMode = .scaleAspectFill
        carouselView.layer.cornerRadius = 10
        cashBackCategory.configureView(
            title: Constants.cashBackTitle,
            image: Images.qr.image,
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
            image: Images.scooter.image,
            backColor: .error,
            titleColor: .pilicanWhite
        )
        cashBackCategory.control.tag = 0
        busCategory.control.tag = 1
        deliveryCategory.control.tag = 2
        taxiCategory.control.tag = 3
        let controls: [Control] = [cashBackCategory, busCategory, deliveryCategory, taxiCategory]

        controls.forEach { control in
            control.control.rx.controlEvent(.touchUpInside)
                .subscribe(onNext: { [unowned self] in
//                    self.selectedTag.onNext(control.control.tag)
                    print(control.control.tag)
                    self.showTag?(control.control.tag)
                }).disposed(by: disposeBag)
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
    }
}
