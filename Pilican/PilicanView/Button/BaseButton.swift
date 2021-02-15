import UIKit

enum ButtonState {
    case enabled
    case disabled
    case highlighted
}

class BaseButton: UIButton {
    var currentState: ButtonState = .enabled {
        didSet {
            updateAppereance()
        }
    }

    override var isEnabled: Bool {
        didSet {
            currentState = isEnabled ? .enabled : .disabled
        }
    }

    override var isHighlighted: Bool {
        didSet {
            currentState = isHighlighted ? .highlighted : .enabled
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func updateAppereance() {}
}
