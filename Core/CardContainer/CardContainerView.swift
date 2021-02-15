import UIKit

final class CardContainerView: UIView {

  private let contentView: UIView = {
    let view = UIView()
    view.layer.cornerRadius = 12
    view.clipsToBounds = true
    return view
  }()

  private let rootView: UIView

  init(rootView: UIView) {
    self.rootView = rootView
    super.init(frame: .zero)
    setupInitialLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupInitialLayout() {

    contentView.addSubview(rootView)
    rootView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    addSubview(contentView)
    contentView.snp.makeConstraints { make in
      make.top.equalToSuperview()
      make.bottom.equalToSuperview().inset(UIViewController.bottomInset + 4)
      make.leading.trailing.equalToSuperview().inset(4)
    }
  }
}
