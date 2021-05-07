import RxSwift
import UIKit

final class MakeOrderCommentView: UIView {
    private let commentTitleView = MakeOrderCommentTitleView()
    private let disposeBag = DisposeBag()
    let textField = TextField()
    
    private lazy var stackView = UIStackView(
        views: [commentTitleView, textField],
        axis: .vertical,
        spacing: 9)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        textField.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        nil
    }

    override func layoutSubviews() {
        layer.cornerRadius = 10
        textField.layer.borderColor = UIColor.clear.cgColor
    }
    
    private func setupInitialLayout() {
        addSubview(stackView)
        commentTitleView.snp.makeConstraints { $0.height.equalTo(40) }
        textField.snp.makeConstraints { $0.height.equalTo(50) }
        stackView.snp.makeConstraints { $0.edges.equalToSuperview().inset(10) }
        commentTitleView.control.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                self.textField.isHidden = false
            })
            .disposed(by: disposeBag)
        backgroundColor = .white
    }
}
