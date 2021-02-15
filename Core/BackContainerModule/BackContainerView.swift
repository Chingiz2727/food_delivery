import UIKit

final class BackContainerView: UIView {

  private let contentView = UIView()

  let backButton = BackButton()

  private let titleLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 1
    label.adjustsFontSizeToFitWidth = true
    return label
  }()

  private let rootView: UIView
  private let trailingTitleView: UIView?

  init(rootView: UIView, trailingTitleView: UIView?) {
    self.rootView = rootView
    self.trailingTitleView = trailingTitleView
    super.init(frame: .zero)
    setupInitialLayout()
    configureView()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupInitialLayout() {
    addSubview(contentView)
    contentView.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide.snp.top)
      make.leading.trailing.bottom.equalToSuperview()
    }

    backButton.snp.makeConstraints { make in
      make.size.equalTo(30)
    }

    let titleView = UIStackView(
      views: [backButton, titleLabel] + (trailingTitleView.map { [$0] } ?? []),
      axis: .horizontal,
      alignment: .center,
      spacing: 10
    )

    contentView.addSubview(titleView)
    titleView.snp.makeConstraints { make in
      make.leading.trailing.top.equalToSuperview().inset(12)
      make.height.equalTo(40)
    }

    contentView.addSubview(rootView)
    rootView.snp.makeConstraints { make in
      make.top.equalTo(titleView.snp.bottom)
      make.leading.trailing.bottom.equalToSuperview()
    }
  }

  private func configureView() {
    contentView.roundTopCorners(radius: 32)
    contentView.clipsToBounds = true
    backgroundColor = .background
    contentView.backgroundColor = .background
    titleLabel.textColor = .pilicanBlack
  }

  func set(title: String?) {
    titleLabel.text = title
  }
}
