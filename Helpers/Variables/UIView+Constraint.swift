import UIKit

public extension UIView {
    func setLayoutSizeConstraints() {
        translatesAutoresizingMaskIntoConstraints = false
        let layoutSize = systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        heightAnchor.constraint(equalToConstant: layoutSize.height).isActive = true
        widthAnchor.constraint(equalToConstant: layoutSize.width).isActive = true
    }

    func setHeightConstraint(_ height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    func setWidthConstraint(_ width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }

    func setSizeConstraints(width: CGFloat, height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }

    func setCenterYConstraint(by view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    func setCenterConstaints(by view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }

    func addSubviewMatchParent(_ subview: UIView, topMargin: CGFloat = 0.0, bottomMargin: CGFloat = 0.0, leftMargin: CGFloat = 0.0, rightMargin: CGFloat = 0.0) {
        addSubview(subview)
        subview.translatesAutoresizingMaskIntoConstraints = false
        subview.topAnchor.constraint(equalTo: topAnchor, constant: topMargin).isActive = true
        subview.leadingAnchor.constraint(equalTo: leadingAnchor, constant: leftMargin).isActive = true
        subview.trailingAnchor.constraint(equalTo: trailingAnchor, constant: rightMargin).isActive = true
        subview.bottomAnchor.constraint(equalTo: bottomAnchor, constant: bottomMargin).isActive = true
    }
}
