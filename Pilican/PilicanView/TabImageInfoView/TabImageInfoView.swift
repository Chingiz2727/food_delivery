import UIKit

final class TabImageInfoView: UIView {
    let control = UIControl()
    let iconImageView = UIImageView()
    let titleLabel = UILabel()
    private let leftView = UIView()
    private let rightView = UIView()
    private lazy var horizontalStackView = UIStackView(
        views: [leftView,iconImageView, titleLabel,rightView],
        axis: .horizontal,
        distribution: .fill,
        alignment: .center,
        spacing: 5)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func layoutSubviews() {
        layer.cornerRadius = 15
    }

    func configureView(backColor: UIColor, icon: UIImage?) {
        backgroundColor = backColor
        iconImageView.image = icon
    }

    func configureTitle(title: String, titleTextColor: UIColor, font: UIFont) {
        titleLabel.text = title.maxLength(length: 15)
        titleLabel.textColor = titleTextColor
        titleLabel.font = font
    }

    private func setupInitialLayout() {
        addSubview(horizontalStackView)
        horizontalStackView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalToSuperview().inset(5)
        }
        addSubview(control)
        control.snp.makeConstraints { $0.edges.equalToSuperview() }
        titleLabel.textAlignment = .left
        iconImageView.contentMode = .scaleAspectFit
        iconImageView.snp.makeConstraints { $0.width.equalTo(20) }
        leftView.snp.makeConstraints { $0.width.equalTo(2) }
        rightView.snp.makeConstraints { $0.width.equalTo(2) }
    }
}
extension String {
   func maxLength(length: Int) -> String {
       var str = self
       let nsString = str as NSString
       if nsString.length >= length {
           str = nsString.substring(with:
               NSRange(
                location: 0,
                length: nsString.length > length ? length : nsString.length)
           )
       }
       return  str
   }
}
