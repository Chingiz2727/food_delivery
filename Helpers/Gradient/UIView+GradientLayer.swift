import UIKit

extension CAGradientLayer {
    static let primaryGradient: CAGradientLayer = {
        let layer = CAGradientLayer()
        layer.colors = [UIColor.primaryGradientColor.cgColor, UIColor.secondaryGradientColor.cgColor]
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
