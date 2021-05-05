//
//  SearchTagsView.swift
//  Pilican
//
//  Created by kairzhan on 5/4/21.
//

import UIKit
import TagListView
import RxSwift

class SearchTagsView: UIView, TagListViewDelegate {
    let dataView = UIView()
    var selectedTag = PublishSubject<String>()
    
    let tagListView = TagListView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayouts()
        configureView()
        setupTagList()
    }

    func setTags(tags: [String]) {
        tags.forEach {
            self.tagListView.addTag($0)
        }
    }

    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        selectedTag.onNext(tagView.titleLabel?.text ?? "")
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupTagList() {
        tagListView.delegate = self
        tagListView.textFont = .book12
        tagListView.alignment = .left
        tagListView.cornerRadius = 12

        tagListView.paddingY = 10
        tagListView.paddingX = 10
        tagListView.marginX = 10
        tagListView.marginY = 10

        for tag in tagListView.tagViews {
            tag.paddingY = 10
            tag.paddingX = 10
        }

        tagListView.backgroundColor = .clear
        tagListView.tagBackgroundColor = .pilicanWhite
        tagListView.textColor = .pilicanGray
        tagListView.borderColor = .pilicanLightGray
        tagListView.selectedTextColor = .primary
        tagListView.tagSelectedBackgroundColor = .pilicanWhite
        tagListView.selectedBorderColor = .primary
    }

    private func setupInitialLayouts() {
        addSubview(dataView)
        dataView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }

        dataView.addSubview(tagListView)
        tagListView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().inset(10)
            make.left.right.equalToSuperview().inset(25)
        }
    }

    private func configureView() {
        dataView.backgroundColor = .background
    }
}
