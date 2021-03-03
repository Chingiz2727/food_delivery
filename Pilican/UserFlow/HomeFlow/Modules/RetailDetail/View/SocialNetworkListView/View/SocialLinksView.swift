import UIKit
import RxSwift
import RxCocoa

public final class SocialLinksView: UIView {

    private let socialLinksStack = UIStackView(
        views: [],
        spacing: 10
    )

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        backgroundColor = .pilicanWhite
    }

    public override func layoutSubviews() {
        layer.cornerRadius = 10
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayout() {
        addSubview(socialLinksStack)
        socialLinksStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.bottom.equalToSuperview().inset(5)
        }
    }

    func setup(links: [SocialNetwork]) {
        var buttons: [UIButton] = []
        links.enumerated().forEach { network in
            switch network.element {
            case
                let .facebook(item),
                let .instagram(item),
                let .phone(item),
                let .telegram(item),
                let .vk(item),
                let .webUrl(item),
                let .whatsappUrl(item),
                let .youtube(item):
                if item != "" {
                    let button = UIButton()
                    button.tag = network.offset
                    button.addTarget(self, action: #selector(didTap(sender:)), for: .touchUpInside)
                    button.setImage(network.element.image, for: .normal)
                    button.snp.makeConstraints { $0.size.equalTo(30) }
                    buttons.append(button)
                }
            }
        }
        buttons.forEach {
            socialLinksStack.addArrangedSubview($0)
        }
        socialLinksStack.addArrangedSubview(UIView())
    }

    @objc fileprivate func didTap(sender: UIButton) { }
}

extension Reactive where Base: SocialLinksView {
    var index: Observable<Int> {
        methodInvoked(#selector(base.didTap(sender:)))
            .compactMap { $0[0] as? UIButton }
            .map { $0.tag }
    }
}
