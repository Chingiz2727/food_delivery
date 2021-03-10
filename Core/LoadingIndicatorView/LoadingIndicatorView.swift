import UIKit
import SnapKit
import Lottie

public final class LoadingIndicatorView: UIView {

  private let animationView: AnimationView = {
    let animation = AnimationView()
    animation.animation = Animation.named("Loader")
    animation.loopMode = .loop
    animation.backgroundBehavior = .pauseAndRestore
    return animation
  }()

  public override init(frame: CGRect) {
    super.init(frame: frame)
    addSubview(animationView)
    animationView.snp.makeConstraints { make in
      make.top.leading.greaterThanOrEqualToSuperview().inset(12)
      make.trailing.bottom.lessThanOrEqualToSuperview().inset(12)
      make.center.equalToSuperview()
      make.size.equalTo(100).priority(.high)
    }
  }

  public required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  public func startAnimating() {
    animationView.play()
  }

  public func stopAnimating() {
    animationView.stop()
  }
}
