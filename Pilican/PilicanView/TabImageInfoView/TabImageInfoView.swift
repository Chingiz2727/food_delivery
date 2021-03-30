import UIKit

final class TabImageInfoView: UIControl {
    private let iconImageView = UIImageView()
    private let titleLabel = UILabel()

    private lazy var horizontalStackView = UIStackView(
        views: [iconImageView, titleLabel],
        axis: .horizontal,
        spacing: 11)

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
            make.leading.trailing.equalToSuperview().inset(20)
            make.top.bottom.equalToSuperview().inset(10)
        }
    }
}
