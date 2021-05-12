import UIKit

extension CAGradientLayer {
    static let primaryGradient: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.primaryGradientColor.cgColor, UIColor.secondaryGradientColor.cgColor]
        layer.startPoint = CGPoint(x: 1, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
        return layer
    }()
    
    static let closedGradient: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.primary.withAlphaComponent(1), UIColor.white.withAlphaComponent(0)]
        layer.startPoint = CGPoint(x: 1, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
        return layer
    }()

    static let greenGradient: CAGradientLayer = {
        let layer = CAGradientLayer()
        let firstColor = #colorLiteral(red: 0.5450980392, green: 0.7647058824, blue: 0.2901960784, alpha: 1)
        let secondColor = #colorLiteral(red: 0.3333333333, green: 0.5450980392, blue: 0.1843137255, alpha: 1)
        layer.colors = [firstColor.cgColor, secondColor.cgColor]
        layer.startPoint = CGPoint(x: 1, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
        return layer
    }()

    static let redGradient: CAGradientLayer = {
        let layer = CAGradientLayer()
        let firstColor = #colorLiteral(red: 0.937254902, green: 0.3254901961, blue: 0.3137254902, alpha: 1)
        let secondColor = #colorLiteral(red: 0.8274509804, green: 0.1843137255, blue: 0.1843137255, alpha: 1)
        layer.colors = [firstColor.cgColor, secondColor.cgColor]
        layer.startPoint = CGPoint(x: 1, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
        return layer
    }()

    static let blueGradient: CAGradientLayer = {
        let layer = CAGradientLayer()
        let firstColor = #colorLiteral(red: 0.09803921569, green: 0.462745098, blue: 0.8235294118, alpha: 1)
        let secondColor = #colorLiteral(red: 0.2588235294, green: 0.6470588235, blue: 0.9607843137, alpha: 1)
        layer.colors = [firstColor.cgColor, secondColor.cgColor]
        layer.startPoint = CGPoint(x: 1, y: 0)
        layer.endPoint = CGPoint(x: 0, y: 1)
        return layer
    }()
}
extension CALayer {
    func addShadow() {
        shadowOffset = CGSize(width: 0, height: 3)
        shadowOpacity = 0.2
        shadowRadius = 1
        shadowColor = UIColor.black.cgColor
        masksToBounds = false
        if cornerRadius != 0 {
            addShadowWithRoundedCorners()
        }
    }
    
    func roundCorners(radius: CGFloat) {
        cornerRadius = radius
        if shadowOpacity != 0 {
            addShadowWithRoundedCorners()
        }
    }

    private func addShadowWithRoundedCorners() {
        if let contents = self.contents {
            masksToBounds = false
            sublayers?.filter { $0.frame.equalTo(bounds) }.forEach { $0.roundCorners(radius: cornerRadius) }
            self.contents = nil
            if let sublayer = sublayers?.first, sublayer.name == "contentLayerName" {
                sublayer.removeFromSuperlayer()
            }
            let contentLayer = CALayer()
            contentLayer.name = "contentLayerName"
            contentLayer.contents = contents
            contentLayer.frame = bounds
            contentLayer.cornerRadius = cornerRadius
            contentLayer.masksToBounds = true
            insertSublayer(contentLayer, at: 0)
        }
    }
}
