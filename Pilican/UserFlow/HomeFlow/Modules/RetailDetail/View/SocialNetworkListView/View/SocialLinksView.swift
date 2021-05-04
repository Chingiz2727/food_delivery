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
    var buttons: [UIButton: SocialNetwork] = [:]

    func setup(links: [SocialNetwork]) {
        links.enumerated().forEach { network in
            let button = UIButton()
            button.tag = network.offset
            button.addTarget(self, action: #selector(didTap(sender:)), for: .touchUpInside)
            button.setImage(network.element.image, for: .normal)
            button.snp.makeConstraints { $0.size.equalTo(30) }
            buttons[button] = network.element

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

                }
            }
        }
        buttons.forEach {
            socialLinksStack.addArrangedSubview($0.key)
        }
        socialLinksStack.addArrangedSubview(UIView())
    }

    @objc fileprivate func didTap(sender: UIButton) {
        let action = buttons[sender]
        switch action {
        case .instagram(let item):
            handleInstagram(url: item)
        case .phone(let item):
            handlePhone(phoneNumber: item)
        case .webUrl(let item):
            handleWeb(url: item)
        case .whatsappUrl(let item):
            handleWA(waNumber: item)
        default:
            return
        }
    }

    private func handleInstagram(url: String) {
        let instagramUrl = URL(string: url)
        UIApplication.shared.canOpenURL(instagramUrl!)
        UIApplication.shared.open(instagramUrl!, options: [:], completionHandler: nil)
    }

    private func handlePhone(phoneNumber: String) {
        if let phoneURL = NSURL(string: ("tel://" + phoneNumber)) {
            UIApplication.shared.open(phoneURL as URL, options: [:], completionHandler: nil)
        }
    }

    private func handleWA(waNumber: String) {
        let whatsappURL = URL(string: waNumber)
        if UIApplication.shared.canOpenURL(whatsappURL!) {
            UIApplication.shared.open(whatsappURL!, options: [:], completionHandler: nil)
        }
    }

    private func handleWeb(url: String) {
        guard let url = URL(string: url), !url.absoluteString.isEmpty else {
            return
        }
        UIApplication.shared.open(url, options: [:], completionHandler: nil)
    }
}

extension Reactive where Base: SocialLinksView {
    var index: Observable<Int> {
        methodInvoked(#selector(base.didTap(sender:)))
            .compactMap { $0[0] as? UIButton }
            .map { $0.tag }
    }
}
