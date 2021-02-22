import UIKit

final class CategoryView: UIControl {

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel = UILabel()
    
    private lazy var verticalStackView = UIStackView(
        views: [imageView, titleLabel],
        axis: .vertical,
        spacing: 4)

    func configureView(title: String, image: UIImage?, backColor: UIColor, titleColor: UIColor) {
        titleLabel.text = title
        imageView.image = image
        backgroundColor = backColor
        titleLabel.textColor = titleColor
    }

    private func setupInitialLayout() {
        addSubview(verticalStackView)
        verticalStackView.snp.makeConstraints { $0.edges.equalToSuperview().inset(10) }
    }
}
