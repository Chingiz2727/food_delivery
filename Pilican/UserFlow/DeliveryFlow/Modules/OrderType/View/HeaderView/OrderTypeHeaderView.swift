import YandexMapsMobile

final class OrderTypeHeaderView: UIView {
    let mapView = YMKMapView()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .semibold20
        label.textColor = .black
        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .medium12
        label.textColor = .black
        return label
    }()
    
    private lazy var stackView = UIStackView(
        views: [titleLabel, descriptionLabel],
        axis: .vertical,
        spacing: 5)
    
    func setupData(retail: DeliveryRetail, avarage: Double) {
        descriptionLabel.text = retail.name
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    private func setupInitialLayout() {
        addSubview(mapView)
        addSubview(stackView)
        
        mapView.snp.makeConstraints { make in
            make.leading.top.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        stackView.snp.makeConstraints { make in
            make.top.equalTo(mapView.snp.bottom).offset(10)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }
    
}
