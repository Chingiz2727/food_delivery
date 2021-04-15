import UIKit

final class AdresssChoiceView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .semibold20
        label.textColor = .black
        label.text = "Адрес доставки"
        return label
    }()
    
    let control = UIControl()
    
    private let adressLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = .medium12
        label.textColor = .pilicanLightGray
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
            make.top.bottom.leading.equalToSuperview().inset(5)
            make.trailing.equalTo(statusIconView.snp.leading).offset(-10)
        }
        statusIconView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview().inset(5)
            make.size.equalTo(22)
        }
    }
    
    private func configureView() {
        containerView.backgroundColor = .background
        containerView.layer.cornerRadius = 8
        backgroundColor = .white
    }
}
