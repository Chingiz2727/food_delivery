import UIKit
import YandexMapsMobile

final class RetailListMapView: UIView {
    let mapView = YMKMapView()
    let tableView = UITableView()
    var drawerView: DrawerView!
    let currentLocationButton: UIButton = {
        let button = UIButton()
        return button
    }()

    let listButton: PrimaryButton = {
        let button = PrimaryButton()
        button.setTitle("Назад к списку", for: .normal)
        button.setTitleColor(.pilicanWhite, for: .normal)
        return button
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        setupDrawerView()
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func setupInitialLayout() {
        addSubview(mapView)
        addSubview(listButton)
        addSubview(currentLocationButton)
        mapView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }

        listButton.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.height.equalTo(50)
        }
        currentLocationButton.snp.makeConstraints { make in
            make.bottom.equalTo(listButton.snp.bottom).offset(30)
            make.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        tableView.registerClassForCell(DeliveryRetailListTableViewCell.self)
    }
    
    private func setupDrawerView() {
        drawerView = DrawerView(scrollView: tableView, delegate: nil, headerView: UIView())
        drawerView.availableStates = [.top, .middle, .bottom]
        drawerView.middlePosition = .fromBottom(300)
        drawerView.cornerRadius = 16
        drawerView.containerView.backgroundColor = .white
        drawerView.animationParameters = .spring(mass: 1, stiffness: 200, dampingRatio: 0.5)
        drawerView.animationParameters = .spring(.default)
        drawerView.setState(.bottom, animated: true)
        addSubview(drawerView)
        drawerView.snp.makeConstraints { $0.edges.equalToSuperview() }
        drawerView.setState(.dismissed, animated: true)
        drawerView.isHidden = true
    }
}
