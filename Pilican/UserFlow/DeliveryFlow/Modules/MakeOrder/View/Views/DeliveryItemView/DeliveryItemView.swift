import UIKit

final class DeliveryItemView: UIView {

    let switchControl = UISwitch()
    let uiControl = UIControl()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .heading2
        label.textAlignment = .left
        return label
    }()

    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .medium12
        label.numberOfLines = 0
        label.textAlignment = .left
        return label
    }()

    private lazy var textStackView = UIStackView(
        views: [titleLabel, descriptionLabel],
        axis: .vertical,
        distribution: .fill,
        spacing: 5)

    private lazy var stackView = UIStackView(
        views: [textStackView, UIView(), switchControl],
        axis: .horizontal,
        distribution: .fill,
        spacing: 10)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func layoutSubviews() {
        layer.cornerRadius = 10
    }

    func setup(title: String, subTitle: String, image: UIImage?) {
        titleLabel.text = title
        descriptionLabel.text = subTitle
        imageView.image = image
    }

    func setup(title: String) {
        titleLabel.text = title
    }

    func setup(subTitle: String) {
        descriptionLabel.text = subTitle
    }

    func setup(image: UIImage?) {
        imageView.image = image
    }

    private func setupInitialLayout() {
        addSubview(uiControl)
        addSubview(stackView)
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(10)
            make.size.equalTo(50)
        }

        uiControl.snp.makeConstraints { $0.edges.equalToSuperview() }
        stackView.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(10)
            make.trailing.top.bottom.equalToSuperview().inset(10)
        }
        imageView.snp.makeConstraints { $0.size.equalTo(40) }
        bringSubviewToFront(uiControl)
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        switchControl.isHidden = true
    }
}
