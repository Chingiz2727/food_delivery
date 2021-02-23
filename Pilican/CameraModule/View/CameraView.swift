import UIKit

final class CameraView: UIView {
    let rotateCameraButton = UIButton()
    let flashLightButton = UIButton()
    let identificatorButton = UIButton()
    let closeButton = UIButton()
    let howItWorkButton = UIButton()
    private let titleLabel = UILabel()
    private let rectangleImageView = UIImageView()
    let contentView = UIView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayout() {
        addSubview(contentView)
        contentView.addSubview(rotateCameraButton)
        contentView.addSubview(flashLightButton)
        contentView.addSubview(identificatorButton)
        contentView.addSubview(closeButton)
        contentView.addSubview(howItWorkButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(rectangleImageView)
        contentView.snp.makeConstraints { $0.edges.equalToSuperview() }
        titleLabel.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(30)
        }

        rectangleImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(300)
            make.top.equalTo(titleLabel.snp.bottom).offset(30)
        }

        flashLightButton.snp.makeConstraints { make in
            make.trailing.equalTo(rectangleImageView)
            make.top.equalTo(rectangleImageView.snp.bottom).offset(30)
            make.size.equalTo(30)
        }

        rotateCameraButton.snp.makeConstraints { make in
            make.leading.equalTo(rectangleImageView)
            make.top.equalTo(rectangleImageView.snp.bottom).offset(30)
            make.size.equalTo(30)
        }

        howItWorkButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(rotateCameraButton.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(30)
        }

        identificatorButton.snp.makeConstraints { make in
            make.top.equalTo(howItWorkButton.snp.bottom).offset(30)
            make.leading.trailing.equalToSuperview().inset(30)
            make.height.equalTo(40)
        }

        closeButton.snp.makeConstraints { make in
            make.size.equalTo(25)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(30)
        }
    }

    private func configureView() {
        titleLabel.text = "Наведите камеру на QR-Code"
        howItWorkButton.setTitle("Как это работает?", for: .normal)
        identificatorButton.setTitle("ИДЕНТИФИКАТОР", for: .normal)
        closeButton.setImage(Images.close.image, for: .normal)
        flashLightButton.setImage(Images.flash.image, for: .normal)
        rotateCameraButton.setImage(Images.rotate.image, for: .normal)
        rectangleImageView.image = Images.Border.image
        titleLabel.textAlignment = .center
        contentView.backgroundColor = .clear
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
    }
}
