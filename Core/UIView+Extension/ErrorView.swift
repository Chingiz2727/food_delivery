import UIKit

public final class ErrorView: UIView {

  private let informationCardView: InformationCardView

  public init(
    title: String,
    subtitle: String,
    image: UIImage?,
    titleFont: UIFont,
    subtitleFont: UIFont,
    retryAction: (() -> Void)? = nil
  ) {

    informationCardView = InformationCardView(
      title: title,
      subtitle: subtitle,
      image: image,
      titleFont: titleFont,
      subtitleFont: subtitleFont,
      buttonTitle: "Повторить",
      buttonAction: retryAction
    )

    super.init(frame: .zero)

    setupInitialLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupInitialLayout() {
    let scrollView = UIScrollView()
    scrollView.showsVerticalScrollIndicator = false
    addSubview(scrollView)
    scrollView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    scrollView.addSubview(informationCardView)
    informationCardView.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(4)
      make.width.leading.width.trailing.bottom.equalToSuperview().inset(4)
    }
    backgroundColor = superview?.backgroundColor
  }
}
