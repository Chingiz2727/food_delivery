import UIKit

final class TextFieldContainer<T: TextField>: UIView {
    let textField = T()

    var title: String? {
        didSet {
            updateTitle()
        }
    }

    let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .pilicanLightGray
        label.backgroundColor = .background
        label.font = UIFont.book14
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayout() {
        addSubview(textField)
        addSubview(titleLabel)

        textField.snp.makeConstraints { $0.edges.equalToSuperview() }
        textField.font = UIFont.medium14

        titleLabel.snp.makeConstraints { make in
            make.centerY.equalTo(textField.snp.top)
            make.leading.equalTo(textField.snp.leading).offset(17)
        }
    }

    func setTitleBackground(background: UIColor) {
        titleLabel.backgroundColor = background
        textField.backgroundColor = background
        backgroundColor = background
    }

    private func updateTitle() {
        titleLabel.text = title
        titleLabel.textColor = .pilicanLightGray
        titleLabel.isHidden = title == nil
    }
}
