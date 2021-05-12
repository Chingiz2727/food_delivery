import YandexMapsMobile
import SnapKit
import UIKit

final class DeliveryLocationMapView: UIView {
    let mapView = YMKMapView()
    let textField = TextField()
    let saveButton = PrimaryButton()
    let currentLocationPin = UIImageView()
    let currentLocationButton = UIButton()
    let tableView = UITableView()
    
    private var contentSizeObserver: NSKeyValueObservation?
    private var heightConstraint: Constraint?
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentSizeObserver = tableView.observe(
            \.contentSize,
            options: [.initial, .new]
        ) { [weak self] tableView, _ in
            self?.heightConstraint?.update(offset: max(40, tableView.contentSize.height))
        }
        setupInitialLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func setupInitialLayout() {
        addSubview(mapView)
        mapView.snp.makeConstraints { $0.edges.equalToSuperview() }
        addSubview(textField)
        addSubview(saveButton)
        addSubview(currentLocationButton)
        addSubview(currentLocationPin)
        addSubview(tableView)
        
        tableView.snp.makeConstraints  { make in
            make.top.equalTo(textField.snp.bottom)
            make.leading.trailing.equalTo(textField)
            heightConstraint = make.height.equalTo(0).constraint
        }
        
        textField.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        saveButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(20)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(40)
        }
        
        currentLocationButton.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(20)
            make.bottom.equalTo(saveButton.snp.top).offset(-30)
            make.size.equalTo(30)
        }
        
        currentLocationPin.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(40)
        }
        
    }
    
    private func configureView() {
        textField.clearButtonMode = .always
        currentLocationPin.image = Images.placeholder.image
        saveButton.setTitleColor(.pilicanWhite, for: .normal)
        saveButton.setTitle("Сохранить", for: .normal)
        tableView.registerClassForCell(UITableViewCell.self)
        currentLocationButton.setBackgroundImage(Images.loc.image, for: .normal)
        tableView.tableHeaderView = nil
        tableView.tableFooterView = nil
        tableView.isHidden = true
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = 40
    }
}
