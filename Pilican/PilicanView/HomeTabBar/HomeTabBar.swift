import RxSwift
import UIKit

final class HomeTabBar: UITabBar {

    private var shapeLayer: CALayer?
    let tabView = HomeTabView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        tintColor = .clear
        unselectedItemTintColor = .clear
    }

    override func draw(_ rect: CGRect) {
        addSubview(tabView)
        tabView.snp.makeConstraints { $0.edges.equalToSuperview() }
        addShape()
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func addShape() {
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = createPathCircle()
        shapeLayer.strokeColor = UIColor.lightGray.cgColor
        shapeLayer.fillColor = UIColor.white.cgColor
        shapeLayer.lineWidth = 0.1

        if let oldShapeLayer = self.shapeLayer {
            self.layer.replaceSublayer(oldShapeLayer, with: shapeLayer)
        } else {
            self.layer.insertSublayer(shapeLayer, at: 0)
        }

        self.shapeLayer = shapeLayer
    }

    func createPathCircle() -> CGPath {
        let radius: CGFloat = 34.0
        let path = UIBezierPath()
        let centerWidth = self.frame.width / 2

        path.move(to: CGPoint(x: 0, y: 0))
        path.addLine(to: CGPoint(x: (centerWidth - radius * 2), y: 0))

        path.addArc(
            withCenter: CGPoint(x: centerWidth, y: 0),
            radius: radius,
            startAngle: CGFloat(180).degreesToRadians,
            endAngle: CGFloat(0).degreesToRadians,
            clockwise: false
        )

        path.addLine(to: CGPoint(x: self.frame.width, y: 0))
        path.addLine(to: CGPoint(x: self.frame.width, y: self.frame.height))
        path.addLine(to: CGPoint(x: 0, y: self.frame.height))
        path.close()

        return path.cgPath
    }
}

extension CGFloat {
    var degreesToRadians: CGFloat { return self * .pi / 180 }
    var radiansToDegrees: CGFloat { return self * 180 / .pi }
}
