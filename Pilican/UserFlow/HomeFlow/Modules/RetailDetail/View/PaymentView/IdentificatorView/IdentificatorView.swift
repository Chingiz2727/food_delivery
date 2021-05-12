import UIKit

final class IdentificatorView: UIControl {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .pilicanBlack
        label.font = .light12
        label.textAlignment = .left
        label.text = "Идентификатор для оплаты"
        return label
    }()

    private let identificatorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .pilicanBlack
        label.font = .medium12
        label.textAlignment = .left
        label.text = "312"
        return label
    }()

    private lazy var stackView = UIStackView(
        views: [titleLabel, identificatorLabel],
        axis: .vertical,
        spacing: 2)

    let payControl = IdentificatorPayControl()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        backgroundColor = .pilicanWhite
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func setData(retail: Retail) {
        identificatorLabel.text = "\(retail.id)"
    }

    private func setupInitialLayout() {
        addSubview(stackView)
        addSubview(payControl)

        stackView.snp.makeConstraints { $0.edges.equalToSuperview().inset(5) }
        payControl.snp.makeConstraints { make in
            make.trailing.bottom.equalToSuperview()
            make.height.equalTo(20)
            make.width.equalTo(90)
        }
    }
}
