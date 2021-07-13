import UIKit

final class RetailDescriptionView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .medium14
        label.textColor = .pilicanBlack
        label.text = "Описание"
        return label
    }()

    private let titleDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .description1
        label.textColor = .pilicanBlack
        label.numberOfLines = 0
        return label
    }()

    private let paymentItemView = RetailItemsView()
    private let optionsItemView = RetailItemsView()
    
    private lazy var verticalStack = UIStackView(
        views: [titleLabel, titleDescriptionLabel, paymentItemView, optionsItemView],
        axis: .vertical,
        spacing: 10)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func setupData(retail: Retail) {
        titleDescriptionLabel.text = retail.description
        paymentItemView.isHidden = retail.paymentOptions.isEmpty
        optionsItemView.isHidden = retail.additionalOptions.isEmpty
        paymentItemView.setupData(title: "Способы оплаты", items: retail.paymentOptions)
        optionsItemView.setupData(title: "Дополнительные опции", items: retail.additionalOptions)
    }

    private func setupInitialLayout() {
        addSubview(verticalStack)
        backgroundColor = .pilicanWhite
        verticalStack.snp.makeConstraints { $0.edges.equalToSuperview().inset(15) }
    }
}
