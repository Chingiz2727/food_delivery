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
        label.font = .medium16
        label.textAlignment = .left
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .regular2
        label.textAlignment = .left
        return label
    }()
    
    private lazy var textStackView = UIStackView(
        views: [titleLabel, descriptionLabel],
        axis: .vertical,
        spacing: 10)
    
    private lazy var stackView = UIStackView(
        views: [imageView, textStackView, UIView(), switchControl],
        axis: .horizontal,
        spacing: 10)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
    }
    
    required init?(coder: NSCoder) {
        nil
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
        uiControl.snp.makeConstraints { $0.edges.equalToSuperview() }
        stackView.snp.makeConstraints  { $0.edges.equalToSuperview() }
    }
}
