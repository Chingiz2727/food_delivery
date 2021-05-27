import UIKit

final class DeliveryButtonsView: UIView {
    
    var addToDish: ((Product) -> Void)?
    var removeFromDish: ((Product) -> Void)?
    
    private var currentDish: Product? {
        didSet {
            countLabel.text = "\(currentDish?.shoppingCount ?? 0)"
            minusButton.isHidden = currentDish?.shoppingCount ?? 0 < 1
            countLabel.isHidden =  currentDish?.shoppingCount ?? 0 < 1
        }
    }

    let plusButton: UIButton = {
        let button = UIButton()
        button.tag = 0
        button.setImage(Images.plus.image, for: .normal)
        button.addTarget(self, action: #selector(setDish(button:)), for: .touchUpInside)
        return button
    }()

    let minusButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.minus.image, for: .normal)
        button.addTarget(self, action: #selector(setDish(button:)), for: .touchUpInside)
        button.tag = 1
        return button
    }()

    let countLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = .medium16
        return label
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [minusButton, countLabel, plusButton])
        stackView.spacing = 10
        stackView.distribution = .equalSpacing
        stackView.axis = .horizontal
        return stackView
    }()

    @objc private func setDish(button: UIButton) {
        guard var dish = currentDish else { return }
        switch button.tag {
        case 0:
            var count = dish.shoppingCount ?? 0
            count += 1
            dish.shoppingCount = count
            self.currentDish = dish
            self.addToDish?(dish)
        case 1:
            var count = dish.shoppingCount ?? 0
            count -= 1
            dish.shoppingCount = count
            self.currentDish = dish
            self.removeFromDish?(dish)
        default:
            break
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func layoutSubviews() {
        layer.cornerRadius = 8
    }
    func setDish(companyDish: Product) {
        currentDish = companyDish
    }

    private func setupInitialLayout() {
        addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(4)
        }
        [plusButton, minusButton].forEach { view in
            view.snp.makeConstraints { $0.size.equalTo(30) }
        }
        backgroundColor = .background
    }
}
