import  UIKit

public final class SegmentItem: UIControl {
    
    var index: Int
        
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .medium12
        return label
    }()
    
    var enabledTextColor: UIColor = .black {
        didSet {
            updateColors()
        }
    }
    
    var disabledTextColor: UIColor = .grayBackground {
        didSet {
            updateColors()
        }
    }
    
    var enabledBackgroundColor: UIColor = .clear {
        didSet {
            updateColors()
        }
    }
    
    var disabledBackgroundColor: UIColor = .background {
        didSet {
            updateColors()
        }
    }
    
    public init(index: Int) {
        self.index = index
        super.init(frame: .zero)
        setupInitialLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInitialLayout() {
        addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(4)
            make.centerX.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview().inset(2)
            make.trailing.lessThanOrEqualToSuperview().inset(2)
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }

    func updateColors() {
        titleLabel.textColor = isEnabled ? enabledTextColor : disabledTextColor
        backgroundColor = isEnabled ? enabledBackgroundColor : disabledBackgroundColor
    }

    func set(title: String) {
        titleLabel.text = title
    }
}
