import Kingfisher
import UIKit

final class OrderStatusProductView: UIView {
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .semibold20
        return label
    }()

    private let countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .right
        label.font = .medium16
        return label
    }()

    private let priceLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .medium16
        return label
    }()

    private lazy var stackView = UIStackView(
        views: [titleLabel, priceLabel, UIView()],
        axis: .vertical,
        distribution: .fill,
        spacing: 5)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func setup(with product: OrderItems?) {
        priceLabel.text = "\(product?.amount ?? 0) 〒"
        titleLabel.text = product?.dish?.name ?? ""
        countLabel.text = "x\(product?.quantity ?? 0)"
        if let url = product?.dish?.img {
            imageView.kf.setImage(with: URL(string: "https://st.pillikan.kz/delivery/\(url)"))
        }
    }

    private func setupInitialLayout() {
        addSubview(imageView)
        addSubview(stackView)
        addSubview(countLabel)
        imageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(14)
            make.centerY.equalToSuperview()
            make.size.equalTo(60)
        }

        stackView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalTo(imageView.snp.trailing).offset(15)
            make.trailing.equalTo(countLabel.snp.leading).offset(-15)
        }

        countLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(14)
        }
        layer.cornerRadius = 12
    }
}
