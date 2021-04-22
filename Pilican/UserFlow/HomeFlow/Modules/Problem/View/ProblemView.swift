import UIKit
import TagListView
import RxSwift

class ProblemView: UIView, TagListViewDelegate {

    let problemLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.medium24
        label.textAlignment = .center
        label.text = "Расскажите нам, что не так?"
        return label
    }()

    let tagListView = TagListView()

    private let claimsList = [
        Claim(id: 1, name: "Другое"),
        Claim(id: 2, name: "Не приняли оплату"),
        Claim(id: 3, name: "Не начислили кэшбэк"),
        Claim(id: 4, name: "Нет  QR-Код"),
        Claim(id: 5, name: "Pillikan не работает здесь"),
        Claim(id: 6, name: "Плохое обслуживание")
    ]

    let textField: TextField = {
        let textField = TextField()
        textField.placeholder = "Опишите проблему подробнее"
        textField.font = UIFont.book16
        return textField
    }()

    let sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("ОТПРАВИТЬ", for: .normal)
        button.setTitleColor(.pilicanWhite, for: .normal)
        button.titleLabel?.font = UIFont.medium16
        button.clipsToBounds = false
        button.layer.cornerRadius = 20
        button.backgroundColor = .primary
        button.layer.addShadow()
        return button
    }()

    var selectedClaimList: [Claim] = []
    let claimids = PublishSubject<String>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setupInitialLayouts()
        setupTagList()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        guard let claim = claimsList.filter({ $0.name == title }).first else { return }
        if !tagView.isSelected {
            selectedClaimList.append(claim)
        } else {
            guard let index = selectedClaimList.firstIndex(of: claim) else { return }
            selectedClaimList.remove(at: index)
        }
        tagView.isSelected = !tagView.isSelected
        let ids = selectedClaimList.map { String($0.id) }
        claimids.onNext(ids.joined(separator: ","))
    }

    private func setupInitialLayouts() {
        addSubview(problemLabel)
        problemLabel.snp.makeConstraints { (make) in
            make.left.top.right.equalToSuperview().inset(16)
        }

        addSubview(tagListView)
        tagListView.snp.makeConstraints { (make) in
            make.top.equalTo(problemLabel.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(16)
        }

        addSubview(textField)
        textField.snp.makeConstraints { (make) in
            make.top.equalTo(tagListView.snp.bottom).offset(30)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }

        addSubview(sendButton)
        sendButton.snp.makeConstraints { (make) in
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
    }

    private func configureView() {
        backgroundColor = .background
    }

    private func setupTagList() {
        tagListView.delegate = self
        tagListView.textFont = .book12
        tagListView.alignment = .left
        tagListView.borderWidth = 0.5
        tagListView.cornerRadius = 15

        tagListView.paddingY = 10
        tagListView.paddingX = 10
        tagListView.marginX = 10
        tagListView.marginY = 10

        for tag in tagListView.tagViews {
            tag.paddingY = 10
            tag.paddingX = 10
        }

        tagListView.backgroundColor = .clear
        tagListView.tagBackgroundColor = .background
        tagListView.textColor = .pilicanGray
        tagListView.borderColor = .pilicanLightGray
        tagListView.selectedTextColor = .primary
        tagListView.tagSelectedBackgroundColor = .background
        tagListView.selectedBorderColor = .primary
        claimsList.forEach {
            self.tagListView.addTag($0.name)
        }
    }
}
