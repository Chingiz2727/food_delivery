import UIKit

final class TabImageInfoView: UIView {
    let control = UIControl()
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()
    
    private lazy var horizontalStackView = UIStackView(
        views: [UIView(),iconImageView, titleLabel, UIView()],
        axis: .horizontal,
        distribution: .equalCentering,
        spacing: 5)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func layoutSubviews() {
        layer.cornerRadius = 15
    }

    func configureView(backColor: UIColor, icon: UIImage?) {
        backgroundColor = backColor
        iconImageView.image = icon
    }

    func configureTitle(title: String, titleTextColor: UIColor, font: UIFont) {
        titleLabel.text = title
        titleLabel.textColor = titleTextColor
        titleLabel.font = font
    }

    private func setupInitialLayout() {
        addSubview(horizontalStackView)
        horizontalStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(5)
            make.top.bottom.equalToSuperview().inset(10)
        }
        addSubview(control)
        control.snp.makeConstraints { $0.edges.equalToSuperview() }
        titleLabel.textAlignment = .left
        iconImageView.contentMode = .scaleAspectFit
    }
}
