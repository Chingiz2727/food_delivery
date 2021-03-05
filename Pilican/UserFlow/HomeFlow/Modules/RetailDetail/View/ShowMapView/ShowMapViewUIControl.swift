import UIKit

final class ShowMapViewUIControl: UIControl {
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .heading2
        label.text = "Показать адрес на карте"
        return label
    }()
    
    private let mapIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Images.map.image
        return imageView
    }()

    private let mapBackgroundImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.image = Images.mapBackground.image
        return imageView
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        backgroundColor = .pilicanWhite
    }

    override func layoutSubviews() {
        layer.cornerRadius = 10
    }

    required init?(coder: NSCoder) {
        nil
    }

    private func setupInitialLayout() {
        addSubview(titleLabel)
        addSubview(mapBackgroundImageView)
        addSubview(mapIcon)
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(15)
        }

        mapBackgroundImageView.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.width.equalTo(137)
        }

        mapIcon.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(15)
            make.size.equalTo(22)
        }
    }
}
