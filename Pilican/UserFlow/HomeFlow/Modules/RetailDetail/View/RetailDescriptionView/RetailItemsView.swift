import UIKit

final class RetailItemsView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .medium14
        return label
    }()

    private lazy var itemsHorizontalStack = UIStackView(
        views: [],
        axis: .horizontal,
        distribution: .fillEqually,
        spacing: 5)

    private lazy var contentStackView = UIStackView(
        views: [titleLabel, itemsHorizontalStack],
        axis: .vertical,
        spacing: 15)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func setupData(title: String, items: [String]) {
        titleLabel.text = title
        setupItems(items: items)
    }

    private func setupInitialLayout() {
        addSubview(contentStackView)
        contentStackView.snp.makeConstraints { $0.edges.equalToSuperview().inset(5) }
    }

    private func setupItems(items: [String]) {
        items.forEach { item in
            let itemView = LabelBackgroundView()
            itemView.configureView(backColor: .clear, textColor: .pilicanBlack)
            itemView.layer.cornerRadius = 8
            itemView.layer.borderWidth = 0.5
            itemView.layer.borderColor = UIColor.pilicanGray.cgColor
            itemView.setTitle(title: item)
            itemView.snp.makeConstraints { $0.height.equalTo(24) }
            itemsHorizontalStack.addArrangedSubview(itemView)
        }
    }
}
