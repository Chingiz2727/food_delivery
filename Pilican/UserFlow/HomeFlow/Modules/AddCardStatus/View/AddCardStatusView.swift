import UIKit

final class AddCardStatusView: UIView {

    let exitButton = PrimaryButton()

    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.numberOfLines = 0
        label.font = .heading1
        label.textColor = .pilicanBlack
        return label
    }()

    private lazy var stackView = UIStackView(
        views: [imageView, titleLabel, exitButton],
        axis: .vertical,
        spacing: 20)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    func setupStatus(status: Status) {
        switch status {
        case .failure:
            imageView.image = Images.orderError.image
            titleLabel.text = "Ошибка привязки карты, попробуйте еще раз"
        case .succes:
            imageView.image = Images.orderSuccess.image
            titleLabel.text = "Карта успешно привязана"
        }
    }

    private func setupInitialLayout() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(30)
            make.center.equalToSuperview()
        }
        exitButton.setTitle("Закрыть", for: .normal)
        exitButton.snp.makeConstraints { $0.height.equalTo(44) }
        backgroundColor = .pilicanWhite
    }
}
