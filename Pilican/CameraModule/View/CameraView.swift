import UIKit
import RxSwift

final class CameraView: UIView {
    let rotateCameraButton = UIButton()
    let flashLightButton = UIButton()
    let identificatorButton = UIButton()
    let closeButton = UIButton()
    let howItWorkButton = UIButton()
    private let titleLabel = UILabel()
    private let rectangleImageView = UIImageView()
    let contentView = UIView()
    let tableView = UITableView()
    
    var drawerView: DrawerView!
    let searchView = SearchHeaderView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        configureView()
        setupDrawerView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayout() {
        addSubview(contentView)
        contentView.snp.makeConstraints { $0.edges.equalToSuperview() }
        contentView.addSubview(rotateCameraButton)
        contentView.addSubview(flashLightButton)
        contentView.addSubview(identificatorButton)
        contentView.addSubview(closeButton)
        contentView.addSubview(howItWorkButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(rectangleImageView)
        contentView.snp.makeConstraints { $0.edges.equalToSuperview() }
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(90)
            make.leading.trailing.equalToSuperview().inset(40)
        }

        rectangleImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.size.equalTo(220)
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
            make.leading.trailing.equalToSuperview().inset(64)
            make.height.equalTo(40)
        }

        closeButton.snp.makeConstraints { make in
            make.size.equalTo(25)
            make.centerX.equalToSuperview()
            make.top.equalTo(identificatorButton.snp.bottom).offset(32)
        }
        tableView.registerClassForCell(CashBackListTableViewCell.self)
    }

    private func configureView() {
        titleLabel.text = "Наведите камеру на QR"
        titleLabel.numberOfLines = 0
        titleLabel.textColor = .pilicanWhite
        howItWorkButton.setTitle("Как это работает?", for: .normal)
        identificatorButton.setTitle("ИДЕНТИФИКАТОР", for: .normal)
        identificatorButton.layer.cornerRadius = 22
        identificatorButton.backgroundColor = .pilicanWhite
        identificatorButton.setTitleColor(.primary, for: .normal)
        closeButton.setImage(Images.close.image, for: .normal)
        flashLightButton.setImage(Images.flash.image, for: .normal)
        rotateCameraButton.setImage(Images.rotate.image, for: .normal)
        rectangleImageView.image = Images.Border.image
        titleLabel.textAlignment = .center
        contentView.backgroundColor = .clear
        backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.6)
    }

    private func setupDrawerView() {
        drawerView = DrawerView(scrollView: tableView, delegate: nil, headerView: searchView)
        drawerView.availableStates = [.top, .middle, .dismissed]
        drawerView.middlePosition = .fromBottom(400)
        drawerView.cornerRadius = 16
        drawerView.containerView.backgroundColor = .white
        drawerView.animationParameters = .spring(mass: 1, stiffness: 200, dampingRatio: 0.5)
        drawerView.animationParameters = .spring(.default)
        drawerView.keyboardDistanceFromTextField = 100
        drawerView.setState(.bottom, animated: true)
        addSubview(drawerView)
        drawerView.snp.makeConstraints { $0.edges.equalToSuperview() }
        drawerView.setState(.dismissed, animated: true)
        drawerView.isHidden = false
        drawerView.headerView.setHeightConstraint(70)
        tableView.separatorStyle = .none
    }
}
