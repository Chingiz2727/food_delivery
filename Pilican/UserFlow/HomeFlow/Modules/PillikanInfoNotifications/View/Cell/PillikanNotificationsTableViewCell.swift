import UIKit

final class PillikanNotificationTableViewCell: UITableViewCell {
    
    let messageImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = Images.pillikanInfo.image?.withRenderingMode(.alwaysOriginal)
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    let messageTitle: UILabel = {
        let label = UILabel()
        label.font = .semibold16
        label.textAlignment = .left
        return label
    }()
    
    let messageText: UILabel = {
        let label = UILabel()
        label.font = .book14
        label.textAlignment = .left
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    let dateLabel: UILabel = {
        let label = UILabel()
        label.font = .medium8
        label.textAlignment = .left
        return label
    }()
    
    lazy var messageStackView = UIStackView(
        views: [messageTitle, messageText, dateLabel],
        axis: .vertical,
        distribution: .fill,
        spacing: 5)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupInitialLayouts()
        selectionStyle = .none
        backgroundColor = .grayBackground
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayouts() {
        addSubview(messageImageView)
        messageImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalToSuperview().inset(15)
            make.size.equalTo(28)
        }

        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(20)
            make.leading.equalTo(messageImageView.snp.trailing).offset(15)
            make.trailing.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(10)
        }

        containerView.addSubview(messageStackView)
        messageStackView.snp.makeConstraints { $0.edges.equalToSuperview().inset(10) }
    }

    func setupNotifications(notification: NotificationInfo) {
        messageTitle.text = notification.title
        messageText.text = notification.description
        dateLabel.text = convertDate(timeResult: notification.createdAt)
    }

    fileprivate func convertDate(timeResult: String) -> String {
        let timeDouble = Double(timeResult)
        let date = Date(timeIntervalSince1970: timeDouble!)
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = DateFormatter.Style.medium //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.dateFormat = "dd/MM/yyyy HH:mm:ss"
        dateFormatter.timeZone = .current
        return dateFormatter.string(from: date)
    }
}
