import UIKit

final class WorkTimeHeaderView: UIView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .description1
        label.textColor = .pilicanBlack
        label.textAlignment = .left
        label.text = "Время работы"
        return label
    }()

    private let workStatus = LabelBackgroundView()

    let expandButton: UIButton = {
        let button = UIButton()
        button.setImage(Images.Path.image, for: .normal)
        button.isHidden = true
        return button
    }()

    private lazy var horizontalStack = UIStackView(
        views: [titleLabel, UIView(), workStatus, expandButton],
        axis: .horizontal,
        distribution: .fill,
        spacing: 10)

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .pilicanWhite
    }

    required init?(coder: NSCoder) {
        nil
    }

    func setupAsHeaderInitialLayout() {
        addSubview(horizontalStack)
        horizontalStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(17)
            make.top.bottom.equalToSuperview().inset(10)
        }
        expandButton.snp.makeConstraints { $0.size.equalTo(15) }
    }

    func setupDetailInitialLayout() {
        addSubview(horizontalStack)
        horizontalStack.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(17)
            make.top.bottom.equalToSuperview().inset(3)
        }
    }
    func setupData(workDay: WorkDay) {
        setupWorkStatusView(workDay: workDay)
    }

    private func setupWorkStatusView(workDay: WorkDay) {
        if let status = WorkStatus(rawValue: workDay.work.intValue) {
            workStatus.setTitle(title: "\(workDay.timeStart) - \(workDay.timeEnd)")
            workStatus.configureView(backColor: status.backColor, textColor: status.textColor)
        }
        titleLabel.text = workDay.title
    }
}
