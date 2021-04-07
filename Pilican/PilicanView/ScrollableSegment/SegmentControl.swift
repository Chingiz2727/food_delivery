import RxSwift
import UIKit

public final class SegmentControl: UIView {
    
    fileprivate var buttons: [SegmentItem] = []
    
    private let contentView = UIStackView(views: [], axis: .horizontal, distribution: .fillEqually, spacing: 2)
    
    public convenience init(titles: [String]) {
        self.init(frame: .zero)
        set(titles: titles)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInitialLayout() {
        addSubview(contentView)
        backgroundColor = .background
        contentView.snp.makeConstraints { $0.edges.equalToSuperview().inset(2) }
    }
    
    private func configureView() {
        clipsToBounds = true
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = bounds.height / 2
    }
    
    private func updateColors() {
        buttons.forEach { $0.updateColors() }
    }
    
    @objc fileprivate func buttonAction(_ sender: UIButton) {
        buttons.forEach { $0.isEnabled = true }
        sender.isEnabled = false
        updateColors()
    }
    
    public func set(titles: [String]) {
        buttons.forEach { $0.removeFromSuperview() }
        buttons = titles.enumerated().map { index, title in
            let button = SegmentItem(index: index)
            button.set(title: title)
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            return button
        }
        if let firstButton = buttons.first {
            perform(#selector(buttonAction(_:)), with: firstButton)
        }
        updateColors()
        buttons.forEach(contentView.addArrangedSubview)
    }
}

public extension Reactive where Base: SegmentControl {
    var selectedIndex: Observable<Int> {
        methodInvoked(#selector(base.buttonAction(_:)))
            .compactMap { $0[0] as? SegmentItem }
            .map { $0.index }
            .startWith(base.buttons.first(where: { !$0.isEnabled })?.index)
            .compactMap { $0 }
    }
}
