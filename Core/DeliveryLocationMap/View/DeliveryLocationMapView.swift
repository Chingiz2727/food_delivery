import YandexMapsMobile
import UIKit

final class DeliveryLocationMapView: UIView {
    let mapView = YMKMapView()
    let textField = TextField()
    let saveButton = PrimaryButton()
    let currentLocationPin = UIImageView()
    let currentLocationButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
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
        currentLocationPin.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(40)
        }
        currentLocationPin.image = Images.placeholder.image
    }
}
