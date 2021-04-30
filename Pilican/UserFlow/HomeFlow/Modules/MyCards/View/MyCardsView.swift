//
//  MyCardsView.swift
//  Pilican
//
//  Created by kairzhan on 3/16/21.
//

import UIKit
import RxSwift
import SnapKit

final class MyCardsView: UIView {
    let tableView = UITableView()
    let addCardButton: UIButton = {
        let button = UIButton()
        button.setTitle( "Добавить карту", for: .normal)
        button.backgroundColor = .primary
        button.clipsToBounds = true
        button.layer.cornerRadius = 20
        button.layer.addShadow()
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.medium16
        return button
    }()
    private var heightConstraint: Constraint?
    private var contentSizeObserver: NSKeyValueObservation?
    private lazy var stackView = UIStackView(
        views: [tableView, addCardButton, UIView()],
        axis: .vertical,
        distribution: .fill,
        spacing: 10)
    private lazy var scrollView = UIScrollView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentSizeObserver = tableView.observe(
            \.contentSize,
            options: [.initial, .new]
        ) { [weak self] tableView, _ in
            self?.heightConstraint?.update(offset: max(40, tableView.contentSize.height))
        }
        setupInitialLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayout() {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { $0.edges.width.height.equalTo(safeAreaLayoutGuide) }
        scrollView.addSubview(stackView)
        stackView.snp.makeConstraints { $0.edges.equalTo(self) }
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalTo(safeAreaLayoutGuide).inset(10)
            heightConstraint = make.height.equalTo(0).constraint
        }
        addCardButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.leading.trailing.equalTo(self).inset(20)
        }
    }

    private func configureView() {
        tableView.backgroundColor = .background
        backgroundColor = .background
    }
}
