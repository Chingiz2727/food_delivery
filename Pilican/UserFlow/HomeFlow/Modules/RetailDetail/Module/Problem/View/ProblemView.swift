//
//  ProblemView.swift
//  Pilican
//
//  Created by kairzhan on 3/4/21.
//

import UIKit
import TagListView
import RxSwift

class ProblemView: UIView, TagListViewDelegate {
    
    let problemLabel: UILabel = {
        let label = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: 301, height: 31)
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
        Claim(id: 6, name: "Плохое обслужование")
    ]
    let textField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Опишите проблему подробнее"
        textField.font = UIFont.book16
        textField.setBottomBorderWhite()
        return textField
    }()

    let sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("ОТПРАВИТЬ", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.medium16
        button.clipsToBounds = false
        button.layer.cornerRadius = 20
        button.backgroundColor = .orange
        button.layer.addShadow()
        return button
    }()

    var selectedClaimList: [Claim] = []
    let claimids = PublishSubject<String>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        setupInitialLayouts()
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
        print("Selected item", selectedClaimList, claimids)
    }

    private func setupInitialLayouts() {
        setupTagList()
        tagListView.delegate = self
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
            make.height.equalTo(21)
        }

        addSubview(sendButton)
        sendButton.snp.makeConstraints { (make) in
            make.top.equalTo(textField.snp.bottom).offset(20)
            make.left.right.equalToSuperview().inset(16)
            make.height.equalTo(40)
        }
    }

    private func configureView() {
        backgroundColor = .white
    }

    fileprivate func setupTagList() {
        tagListView.textFont = UIFont(name: "Whitney-Book", size: 12)!
        tagListView.alignment = .left
        tagListView.borderColor = .white
        tagListView.borderWidth = 1
        tagListView.cornerRadius = 8

        tagListView.paddingY = 5
        tagListView.paddingX = 5
        tagListView.marginX = 5
        tagListView.marginY = 5
        for tag in tagListView.tagViews {
            tag.paddingY = 5
            tag.paddingX = 5
        }
        tagListView.backgroundColor = .clear
        tagListView.tagBackgroundColor = .white
        tagListView.textColor = .gray
        tagListView.borderColor = .gray
        tagListView.selectedTextColor = .orange
        tagListView.tagSelectedBackgroundColor = .white
        tagListView.selectedBorderColor = .orange
        claimsList.forEach {
            self.tagListView.addTag($0.name)
        }
    }
}

struct Claim: Equatable {
    let id: Int
    let name: String
}
