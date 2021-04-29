import UIKit

final class PinView: UIView {
    let label: UILabel = {
        let label = UILabel()
        label.font = .semibold24
        label.textAlignment = .center
        return label
    }()
    
    let contentView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        layer.cornerRadius = 16
        layer.borderColor = UIColor.primary.cgColor
        layer.borderWidth = 0.5
        translatesAutoresizingMaskIntoConstraints = false
    }

    private func setupInitialLayout() {
        addSubview(contentView)
        contentView.addSubview(label)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(10)
        }
        label.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(5)
        }
    }
}
