import UIKit

public final class BackButton: UIButton {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        setImage(Images.close.image, for: .normal)
    }

    private func setupInitialLayout() {
        snp.makeConstraints { make in
            make.size.equalTo(36)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
