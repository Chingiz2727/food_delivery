import UIKit

final class PassCodeView: UIView, UITextInputTraits {
    var keyboardType: UIKeyboardType = .numberPad

    var didFinishedEnterCode:((String)-> Void)?

    var code: String  = "" {
        didSet {
            updateStackByCode(code: code)
            if code.count == codeLenght, let didFinishedEnterCode = didFinishedEnterCode {
                self.resignFirstResponder()
                didFinishedEnterCode(code)
            }
        }
    }

    var codeLenght: Int = 4
    
    private let emptyView: PinView = {
        let emptyView = PinView()
        emptyView.contentView.backgroundColor = .primary
        emptyView.label.textColor = .white
        return emptyView
    }()
    
    private let filledView: PinView = {
        let filledView = PinView()
        filledView.contentView.backgroundColor = .white
        filledView.label.textColor = .primary
        return filledView
    }()
    
    private lazy var stackView = UIStackView(
        views: [],
        axis: .horizontal,
        distribution: .fillEqually,
        spacing: 15)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        showKeyboardIfNeeded()
    }
    
    required init?(coder: NSCoder) {
        nil
    }

    private func setupInitialLayout() {
        addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalToSuperview() }
        updateStackByCode(code: code)
        backgroundColor = .clear
    }
    
    private func updateStackByCode(code: String) {
        var emptyPins: [PinView] = Array(0..<codeLenght).map { _ in emptyView }
        
        let userPinLength = code.count
        let pins: [PinView] = Array(0..<userPinLength).map { _ in filledView }
        for (index,element) in pins.enumerated() {
            emptyPins[index] = element
        }
    
        for view in emptyPins {
            view.label.text = code
            stackView.addArrangedSubview(view)
        }
    }
}

extension PassCodeView {
    
    override var canBecomeFirstResponder: Bool {
        true
    }
    
    private func showKeyboardIfNeeded() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(showKeyboard))
        addGestureRecognizer(tapGesture)
    }
    
    @objc private func showKeyboard() {
        becomeFirstResponder()
    }
}

extension PassCodeView: UIKeyInput {
    var hasText: Bool {
        code.count > 0
    }
    
    func insertText(_ text: String) {
        if code.count == codeLenght { return }
        code.append(contentsOf: text)
        print(text)
    }
    
    func deleteBackward() {
        if hasText {
            code.removeLast()
        }
    }
}

extension UIStackView {
    
    func removeAllArrangedSubviews() {
        
        let removedSubviews = arrangedSubviews.reduce([]) { (allSubviews, subview) -> [UIView] in
            self.removeArrangedSubview(subview)
            return allSubviews + [subview]
        }
        
        // Deactivate all constraints
        NSLayoutConstraint.deactivate(removedSubviews.flatMap({ $0.constraints }))
        
        // Remove the views from self
        removedSubviews.forEach({ $0.removeFromSuperview() })
    }
}
