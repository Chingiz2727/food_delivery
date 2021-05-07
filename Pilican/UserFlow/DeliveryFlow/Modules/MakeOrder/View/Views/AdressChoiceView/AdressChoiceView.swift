import UIKit

final class AdresssChoiceView: UIView {
    let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .semibold20
        label.textColor = .black
        label.text = "Адрес доставки"
        return label
    }()
    
    let control = UIControl()

    let adressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .medium16
        label.textColor = .pilicanBlack
        return label
    }()

    private let statusIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Images.checkD.image
        return imageView
    }()

    private let containerView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func setupAdressName(adress: String) {
        adressLabel.text = adress
    }

    private func setupInitialLayout() {
        addSubview(titleLabel)
        addSubview(containerView)
        containerView.addSubview(adressLabel)
        containerView.addSubview(statusIconView)

        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(5)
            make.leading.trailing.equalToSuperview().inset(10)
        }

        containerView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.height.equalTo(40)
            make.bottom.leading.trailing.equalToSuperview().inset(10)
        }

        adressLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.leading.equalToSuperview().inset(10)
            make.trailing.equalTo(statusIconView.snp.leading).offset(-10)
        }
        statusIconView.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(5)
            make.trailing.equalToSuperview().inset(10)
            make.size.equalTo(22)
        }
        containerView.addSubview(control)
        control.snp.makeConstraints { $0.edges.equalToSuperview() }
    }

    private func configureView() {
        containerView.backgroundColor = .background
        containerView.layer.cornerRadius = 8
        backgroundColor = .white
    }
}
