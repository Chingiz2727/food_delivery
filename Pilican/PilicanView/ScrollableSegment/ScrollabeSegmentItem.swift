import UIKit

public class ScrollabeSegmentItem: UIControl {
    
    var index: Int
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .semibold18
        label.numberOfLines = 1
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
    
    var enabledBackgroundColor: UIColor = .white {
        didSet {
            updateColors()
        }
    }
    
    var disabledBackgroundColor: UIColor = .black {
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
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 8
        layer.shadowOpacity = 0.05
    }

    private func updateColors() {
        titleLabel.textColor = isEnabled ? enabledTextColor : disabledTextColor
        backgroundColor = isEnabled ? enabledBackgroundColor : disabledBackgroundColor
    }

    func set(title: String) {
        titleLabel.text = title
    }
}
