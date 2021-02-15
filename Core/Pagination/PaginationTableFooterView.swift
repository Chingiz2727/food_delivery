import UIKit

public final class PaginationTableFooterView: UIView {

  public let retryButton = UIButton()

  private let errorLabel: UILabel = {
    let label = UILabel()
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()

  public override var intrinsicContentSize: CGSize {
    return CGSize(width: UIView.noIntrinsicMetric, height: 60)
  }

  public override init(frame: CGRect) {
    super.init(frame: frame)
    setupInitialLayout()
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func configure(state: PaginationState) {
    errorLabel.isHidden = !state.isError
    retryButton.isHidden = !state.isError
    if case let .error(error) = state {
      errorLabel.text = error.localizedDescription
    }
  }

  private func setupInitialLayout() {
    addSubview(errorLabel)
    errorLabel.snp.makeConstraints { make in
      make.top.equalToSuperview().inset(12)
      make.leading.equalTo(snp.leadingMargin)
      make.trailing.equalTo(snp.trailingMargin)
    }

    addSubview(retryButton)
    retryButton.snp.makeConstraints { make in
      make.top.equalTo(errorLabel.snp.bottom).offset(12)
      make.leading.equalTo(snp.leadingMargin)
      make.trailing.equalTo(snp.trailingMargin)
      make.bottom.equalToSuperview().inset(12)
    }
  }
}

private extension PaginationTableFooterView {

  enum Constants {
    static let animationSize = 90
  }
}
