import UIKit

public extension UIStackView {

  convenience init(
    views: [UIView],
    axis: NSLayoutConstraint.Axis = .horizontal,
    distribution: Distribution = .fill,
    alignment: Alignment = .fill,
    spacing: CGFloat = 0
  ) {
    self.init(arrangedSubviews: views)
    self.axis = axis
    self.distribution = distribution
    self.alignment = alignment
    self.spacing = spacing
  }
}
