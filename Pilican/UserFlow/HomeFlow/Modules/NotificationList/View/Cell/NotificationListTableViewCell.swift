import UIKit

final class NotificationListTableViewCell: UITableViewCell {
    
    let notificationImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFit
        iv.clipsToBounds = true
        return iv
    }()
    
    let notificationTitleText: UILabel = {
        let label = UILabel()
        label.font = .semibold16
        label.textColor = .black
        return label
    }()
    
    let infoDescriptionLabel: UILabel = {
        let label = UILabel()
        label.font = .book12
        label.textColor = .black
        return label
    }()
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupInitialLayouts()
        selectionStyle = .none 
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupInitialLayouts() {
        contentView.addSubview(notificationImageView)
        notificationImageView.snp.makeConstraints { make in
            make.top.leading.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(15)
        }
        
        contentView.addSubview(notificationTitleText)
        notificationTitleText.snp.makeConstraints { make in
            make.top.equalTo(notificationImageView.snp.top)
            make.leading.equalTo(notificationImageView.snp.trailing).offset(15)
        }
        
        contentView.addSubview(infoDescriptionLabel)
        infoDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(notificationTitleText.snp.bottom)
            make.leading.equalTo(notificationTitleText.snp.leading)
        }
    }
    
    func setupTexts(notification: NotificationsList) {
        notificationImageView.image = UIImage(named: notification.img)
        notificationTitleText.text = notification.titleText
        infoDescriptionLabel.text = notification.descriptionText
        
    }
    
}
