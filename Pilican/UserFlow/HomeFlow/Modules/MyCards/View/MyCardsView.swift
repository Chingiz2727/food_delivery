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
    let footerView = MyCardsFooterView()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupInitialLayout() {
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.bottom.equalTo(safeAreaLayoutGuide).inset(10)
        }
    }

    private func configureView() {
        tableView.backgroundColor = .background
        backgroundColor = .background
    }
}
