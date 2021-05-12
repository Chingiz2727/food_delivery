import UIKit

final class MakeOrderCommentTitleView: UIView {
    let control = UIControl()
    
    private let subTitle: UILabel = {
        let label = UILabel()
        label.font = .book14
        label.textColor = .black
        label.text = "(Особые запросы, аллергия и т.д.)"
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .semibold16
        label.textColor = .black
        label.text = "Комментарий для ресторана"
        return label
    }()
    
    private let commentImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Images.commentss.image
        return imageView
    }()

    private lazy var textStackView = UIStackView(
        views: [titleLabel, subTitle],
        axis: .vertical,
        spacing: 3)
    
    private lazy var stackView = UIStackView(
        views: [commentImageView, textStackView],
        axis: .horizontal,
        distribution: .fillProportionally,
        spacing: 10)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
    }

    required init?(coder: NSCoder) {
        nil
    }
    
    private func setupInitialLayout() {
        addSubview(stackView)
        addSubview(control)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        control.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
