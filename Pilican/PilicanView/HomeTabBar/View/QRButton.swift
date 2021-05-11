import UIKit

final class QRButton: UIView {
    let control = UIControl()
    private let imageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func setupInitialLayout() {
        addSubview(imageView)
        addSubview(control)
        imageView.image = Images.mainqr.image
        imageView.contentMode = .scaleAspectFit
        imageView.snp.makeConstraints { $0.edges.equalToSuperview() }
        control.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
}
