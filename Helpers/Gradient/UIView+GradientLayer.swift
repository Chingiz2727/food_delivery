import UIKit

extension UIView {
    func addPrimaryGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [UIColor.primaryGradientColor.cgColor, UIColor.secondaryGradientColor.cgColor]
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
