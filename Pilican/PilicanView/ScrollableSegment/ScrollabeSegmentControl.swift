import RxSwift
import UIKit

public final class ScrollabeSegmentControl: UIView {
    
    var selectedTextColor: UIColor = .white
    var deslectedTextColor: UIColor = .black
    var selectedBackgroundColor: UIColor = .primary
    var deselectedBackgroundColor: UIColor = .clear
    
    fileprivate var buttons: [ScrollabeSegmentItem] = []
    
    private let contentView = UIStackView(
        views: [],
        axis: .horizontal,
        distribution: .fillProportionally,
        spacing: 4
    )
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.clipsToBounds = false
        return scrollView
    }()
    
    public convenience init(titles: [String]) {
        self.init(frame: .zero)
        set(titles: titles)
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayout() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        scrollView.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.top.leading.bottom.height.equalToSuperview().inset(2)
            make.trailing.lessThanOrEqualToSuperview().inset(2)
        }
    }
    
    func updateColors() {
        buttons.forEach { button in
            button.enabledTextColor = deslectedTextColor
            button.disabledTextColor = selectedTextColor
            button.enabledBackgroundColor = deselectedBackgroundColor
            button.disabledBackgroundColor = selectedBackgroundColor
        }
    }
    
    @objc fileprivate func buttonAction(_ sender: UIControl) {
        buttons.forEach { $0.isEnabled = true }
        sender.isEnabled = false
        updateColors()
    }

    public func set(titles: [String]) {
        buttons.forEach { $0.removeFromSuperview() }
        buttons = titles.enumerated().map { index, title in
            let button = ScrollabeSegmentItem(index: index)
            button.set(title: title)
            button.tag = index
            button.addTarget(self, action: #selector(buttonAction(_:)), for: .touchUpInside)
            return button
        }
        if let firstButton = buttons.first {
            perform(#selector(buttonAction(_:)), with: firstButton)
        }
        updateColors()
        buttons.forEach(contentView.addArrangedSubview)
    }

    public func colorAtIndex(index: Int) {
        buttons.forEach { $0.isEnabled = true }
        buttons[index].isEnabled = false
        updateColors()
        scrollView.scrollToView(view: buttons[index], animated: true)
    }
}

extension UIScrollView {
    func scrollToView(view: UIView, animated: Bool) {
        if let superview = view.superview {
            let child = superview.convert(view.frame, to: self)
            let visible = CGRect(origin: contentOffset, size: visibleSize)
            let newOffsetY = child.minX < visible.minX ? child.minX : child.maxX > visible.maxX ? child.maxX - visible.width : nil
            if let x = newOffsetY {
                setContentOffset(CGPoint(x: x, y: 0), animated: animated)
            }
        }
    }
}

public extension Reactive where Base: ScrollabeSegmentControl {
    var selectedIndex: Observable<Int> {
        methodInvoked(#selector(base.buttonAction(_:)))
            .compactMap { $0[0] as? ScrollabeSegmentItem }
            .map { $0.index }
            .startWith(base.buttons.first(where: { !$0.isEnabled })?.index)
            .compactMap { $0 }
    }
}
