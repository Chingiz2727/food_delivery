import UIKit

public class InformationCardView: UIView {
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        return imageView
    }()
    
    private var actionButton = PrimaryButton()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.textAlignment = .center
        return label
    }()
    
    private var buttonAction: (() -> Void)?
    
    public convenience init(
      title: String?,
      subtitle: String?,
      image: UIImage?,
      titleFont: UIFont,
      subtitleFont: UIFont,
      buttonTitle: String? = nil,
      buttonAction: (() -> Void)? = nil,
      imageTintColor: UIColor? = nil
    ) {

      self.init()

      set(titleFont: titleFont, subtitleFont: subtitleFont)
      set(image: image, title: title, subtitle: subtitle)
      set(buttonTitle: buttonTitle, buttonAction: buttonAction)
      setImageTintColor(imageTintColor)
    }

    public init() {
      super.init(frame: .init())
      setupInitialLayout()
      configureView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInitialLayout() {
        let stackView = UIStackView(
            views: [iconImageView, titleLabel, subtitleLabel, actionButton],
            axis: .vertical
        )
        stackView.setCustomSpacing(16, after: iconImageView)
        stackView.setCustomSpacing(8, after: subtitleLabel)
        
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(16)
        }
    }
    
    private func configureView() {
        layer.cornerRadius = 8
        actionButton.layer.cornerRadius = 8
        
        layer.shadowOffset = CGSize(width: 0, height: 1)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.1
        
        actionButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
    }
    
    @objc private func buttonPressed() {
        buttonAction?()
    }
}

public extension InformationCardView {
    
    func set(image: UIImage?, title: String?, subtitle: String?) {
        iconImageView.image = image
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    func setImage(_ image: UIImage?) {
        iconImageView.image = image
    }
    
    func setImageTintColor(_ tintColor: UIColor?) {
        guard let safeTintColor = tintColor else { return }
        iconImageView.tintColor = safeTintColor
    }
    
    func setTexts(title: String?, subtitle: String?) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    func set(titleFont: UIFont, subtitleFont: UIFont) {
        titleLabel.font = titleFont
        subtitleLabel.font = subtitleFont
    }
    
    func set(buttonTitle: String?, buttonAction: (() -> Void)?) {
        actionButton.setTitle(buttonTitle, for: .normal)
        self.buttonAction = buttonAction
        actionButton.isHidden = buttonAction == nil
    }
}
