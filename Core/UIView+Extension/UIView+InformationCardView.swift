import UIKit
import RxSwift
import RxCocoa

public extension UIView {

  private enum AssociatedKeys {
    static var informationCardView = "information_card_view_key"
  }

  private var informationCardView: InformationCardView! {
    get {
      return objc_getAssociatedObject(self, &AssociatedKeys.informationCardView) as? InformationCardView
    }
    set {
      objc_setAssociatedObject(self, &AssociatedKeys.informationCardView, newValue, .OBJC_ASSOCIATION_RETAIN)
    }
  }

  func showInformationCardView(
    title: String?,
    subtitle: String?,
    buttonTitle: String?,
    titleFont: UIFont = .semibold20,
    subtitleFont: UIFont = .medium12,
    image: UIImage? = nil,
    defaultAction: (() -> Void)? = nil,
    paddingFromTop: CGFloat = 4,
    imageTintColor: UIColor? = nil
  ) {
    informationCardView?.removeFromSuperview()

    informationCardView = InformationCardView(
      title: title,
      subtitle: subtitle,
      image: image,
      titleFont: titleFont,
      subtitleFont: subtitleFont,
      buttonTitle: buttonTitle,
      buttonAction: defaultAction ?? { [weak self] in self?.defaultAction() },
      imageTintColor: imageTintColor
    )
    addSubview(informationCardView)
    informationCardView.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(paddingFromTop)
      make.leading.trailing.equalToSuperview().inset(4)
    }
  }

  func hideInformationCardView() {
    informationCardView?.removeFromSuperview()
    informationCardView = nil
  }

  @objc fileprivate func defaultAction() {}
}
