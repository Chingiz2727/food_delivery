import UIKit

final class PrimaryButton: BaseButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }

    override func updateAppereance() {
        switch currentState {
        case .enabled:
            configureView()
        case .disabled:
            configureDisabled()
        case .highlighted:
            configureHighlighted()
        }
    }

    private func configureView() {
        backgroundColor = .primary
        layer.cornerRadius = 20
        setTitleColor(.white, for: .normal)
    }

    private func configureDisabled() {
        backgroundColor = UIColor.primary.withAlphaComponent(0.4)
    }

    private func configureHighlighted() {
        backgroundColor = .primary
    }
}
