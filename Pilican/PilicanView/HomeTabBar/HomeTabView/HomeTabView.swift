import UIKit

final class HomeTabView: UIView {
    let userInfoView = TabImageInfoView()
    let balanceInfoView = TabImageInfoView()

    let qrScanButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.mainqrcode.image, for: .normal)
        button.layer.cornerRadius = 35
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.isUserInteractionEnabled = true
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func setupInitialLayout() {
        addSubview(userInfoView)
        addSubview(balanceInfoView)
        addSubview(qrScanButton)

        userInfoView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(18)
            make.height.equalTo(31)
        }

        balanceInfoView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(18)
            make.height.equalTo(31)
        }

        qrScanButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.top)
            make.centerX.equalToSuperview()
            make.size.equalTo(70)
        }
    }

    private func configureView() {
        userInfoView.configureView(backColor: #colorLiteral(red: 0.8823529412, green: 0.9607843137, blue: 0.9960784314, alpha: 1), icon: Images.avatar.image)
        balanceInfoView.configureView(backColor: .blue, icon: Images.cashback.image)
        qrScanButton.backgroundColor = .primary
    }
}
