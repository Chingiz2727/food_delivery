import UIKit

final class LabelBackgroundView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .description3
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitiallayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setTitle(title: String) {
        titleLabel.text = title
    }
    
    func configureView(backColor: UIColor, textColor: UIColor) {
        backgroundColor = backColor
        titleLabel.textColor = textColor
    }
    
    private func setupInitiallayout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { $0.edges.equalToSuperview().inset(5) }
    }
    
    override func layoutSubviews() {
        layer.cornerRadius = 6
    }
}
