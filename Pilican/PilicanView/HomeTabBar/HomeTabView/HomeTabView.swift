import UIKit

final class HomeTabView: UIView {
    let userInfoView = TabImageInfoView()
    let balanceInfoView = TabImageInfoView()

    let qrScanButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.mainqr.image, for: .normal)
        button.layer.cornerRadius = 35
        button.clipsToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
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

    func setData(profile: String, balance: String) {
        userInfoView.configureTitle(title: profile, titleTextColor: .profile, font: UIFont.medium10)
        balanceInfoView.configureTitle(title: balance, titleTextColor: .primary, font: UIFont.medium10)
    }

    private func setupInitialLayout() {
        addSubview(userInfoView)
        addSubview(balanceInfoView)
        addSubview(qrScanButton)

        userInfoView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(18)
            make.height.equalTo(31)
            make.width.equalTo(105)
        }

        balanceInfoView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(18)
            make.height.equalTo(31)
            make.width.equalTo(105)
        }

        qrScanButton.snp.makeConstraints { make in
            make.centerY.equalTo(self.snp.top)
            make.centerX.equalToSuperview()
            make.size.equalTo(70)
            
        }
    }

    private func configureView() {
        userInfoView.configureView(backColor: #colorLiteral(red: 0.8823529412, green: 0.9607843137, blue: 0.9960784314, alpha: 1), icon: Images.avatar.image)
        balanceInfoView.configureView(backColor: .cashbackOrange, icon: Images.cashback.image)
        balanceInfoView.isUserInteractionEnabled = true
        userInfoView.isUserInteractionEnabled = true
    }
}
