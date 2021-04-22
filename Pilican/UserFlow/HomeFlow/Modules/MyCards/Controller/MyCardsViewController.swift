//
//  MyCardsViewController.swift
//  Pilican
//
//  Created by kairzhan on 3/16/21.
//

import UIKit
import RxSwift

final class MyCardsViewController: ViewController, ViewHolder, MyCardsModule {
    var closeButton: CloseButton?
    
    typealias RootViewType = MyCardsView
    
    var addCard: Callback?
    
    private let disposeBag = DisposeBag()
    private let viewModel: MyCardsViewModel
    private let removeSubjectId = PublishSubject<Int>()
    private let setMainSubjectId = PublishSubject<Int>()
    private let reloadTableView = PublishSubject<Void>()
    init(viewModel: MyCardsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func loadView() {
        view = MyCardsView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        bindView()
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(
            input: .init(
                loadCards: Observable.merge(.just(()), reloadTableView),
                removeCard: removeSubjectId,
                setMainCard: setMainSubjectId))
        
        let list = output.result.publish()
        
        list.element.map { $0.cards }
            .bind(to: rootView.tableView.rx.items(MyCardsTableViewCell.self)) { _, model, cell in
                cell.setupData(card: model)
            }
            .disposed(by: disposeBag)
        
        list.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)
        
        list.loading
            .bind(to: ProgressView.instance.rx.loading)
            .disposed(by: disposeBag)
        
        list.connect()
            .disposed(by: disposeBag)
        
        rootView.tableView.rx.itemSelected
            .withLatestFrom(list.element) { index, card in
                return card.cards[index.row].id
            }.subscribe(onNext: { [unowned self] cardId in
                self.setMainSubjectId.onNext(cardId)
            })
            .disposed(by: disposeBag)
        
        let setMain = output.cardSetMain.publish()
        
        setMain.subscribe(onNext: { [unowned self] _ in
//            self.reloadTableView.onNext(())
        }).disposed(by: disposeBag)
        
        setMain.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)
        
        setMain.loading
            .bind(to: ProgressView.instance.rx.loading)
            .disposed(by: disposeBag)
        
        setMain.connect()
            .disposed(by: disposeBag)
    }

    private func bindView() {
        rootView.tableView.setSizedFooterView(rootView.footerView)
        rootView.tableView.registerClassForCell(MyCardsTableViewCell.self)
        rootView.tableView.separatorStyle = .none
        rootView.footerView.addCardButton.rx.tap.subscribe(onNext: { [unowned self] in
            self.addCard?()
        }).disposed(by: disposeBag)
    }
    
    override func customBackButtonDidTap() {
        closeButton?()
    }
}
