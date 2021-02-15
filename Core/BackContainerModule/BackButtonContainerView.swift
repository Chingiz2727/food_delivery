import UIKit

final class BackButtonContainerView: UIView {

  let backButton = BackButton()

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

    addSubview(rootView)
    rootView.snp.makeConstraints { make in
      make.edges.equalToSuperview()
    }

    addSubview(backButton)
    backButton.snp.makeConstraints { make in
      make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(16)
      make.trailing.equalToSuperview().inset(16)
    }
  }
}
