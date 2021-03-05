import UIKit

final class CategoryView: UIView {
    let control = UIControl()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        return imageView
    }()

    private let backView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.pilicanBlack.withAlphaComponent(0.07)
        view.layer.cornerRadius = 10
        view.isUserInteractionEnabled = true
        return view
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .description3
        label.numberOfLines = 1
        label.isUserInteractionEnabled = true
        label.textAlignment = .center
        return label
    }()

    private lazy var verticalStackView = UIStackView(
        views: [backView, titleLabel],
        axis: .vertical,
        spacing: 4)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
    }

    override func layoutSubviews() {
        clipsToBounds = true
        layer.cornerRadius = 12
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func configureView(title: String, image: UIImage?, backColor: UIColor, titleColor: UIColor) {
        titleLabel.text = title
        imageView.image = image
        backgroundColor = backColor
        titleLabel.textColor = titleColor
        isUserInteractionEnabled = true
    }

    private func setupInitialLayout() {
        addSubview(titleLabel)
        addSubview(backView)
        addSubview(control)
        control.snp.makeConstraints { $0.edges.equalToSuperview() }
        backView.addSubview(imageView)

        backView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.size.equalTo(40)
        }

        imageView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(24)
        }

        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.bottom.equalToSuperview().inset(8)
            make.leading.trailing.equalToSuperview().inset(2)
        }
    }
}
