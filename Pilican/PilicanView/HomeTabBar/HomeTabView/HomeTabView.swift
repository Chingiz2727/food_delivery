import UIKit

final class HomeTabView: UIView {
    let userInfoView = TabImageInfoView()
    let balanceInfoView = TabImageInfoView()

    let qrScanButton = QRButton()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func setData(profile: String, balance: String) {
        userInfoView.configureTitle(title: profile, titleTextColor: .profile, font: UIFont.medium12)
        balanceInfoView.configureTitle(title: balance, titleTextColor: .primary, font: UIFont.medium12)
    }

    private func setupInitialLayout() {
        addSubview(userInfoView)
        addSubview(balanceInfoView)
//        addSubview(qrScanButton)

        userInfoView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(18)
            make.width.equalTo(90)
        }

        balanceInfoView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(18)
            make.width.equalTo(90)
        }
    }

    private func configureView() {
        userInfoView.configureView(backColor: #colorLiteral(red: 0.8823529412, green: 0.9607843137, blue: 0.9960784314, alpha: 1), icon: Images.avatar.image)
        balanceInfoView.configureView(backColor: .cashbackOrange, icon: Images.newBonusPrimary.image)
        balanceInfoView.isUserInteractionEnabled = true
        userInfoView.isUserInteractionEnabled = true
        backgroundColor = .white
    }
}
