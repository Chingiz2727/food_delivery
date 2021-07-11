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
    
    var addCard: AddCard?
    
    private let disposeBag = DisposeBag()
    private let viewModel: MyCardsViewModel
    private let removeSubjectId = PublishSubject<Int>()
    private let setMainSubjectId = PublishSubject<Int>()
    private let reloadTableView = PublishSubject<Void>()
    private let cardName = PublishSubject<String?>()
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
        title = "Мои карты"
        navigationController?.navigationBar.isHidden = false
        addCustomizedNotifyBar()
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
                cell.removeCard = { [weak self] in
                    print(model)
                }
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
                self.showCardAlerAlert(cardId: cardId)
            })
            .disposed(by: disposeBag)
        
        let setMain = output.cardSetMain.publish()
        
        setMain.element.subscribe(onNext: { [unowned self] data in
            self.reloadTableView.onNext(())
        }).disposed(by: disposeBag)
        
        setMain.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)
        
        setMain.loading
            .bind(to: ProgressView.instance.rx.loading)
            .disposed(by: disposeBag)
        
        setMain.connect()
            .disposed(by: disposeBag)
        
        let deleteCard = output.cardSetRemove.publish()
        
        deleteCard.element.subscribe(onNext: { [unowned self] data in
            self.reloadTableView.onNext(())
        }).disposed(by: disposeBag)
        
        deleteCard.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)
        
        deleteCard.loading
            .bind(to: ProgressView.instance.rx.loading)
            .disposed(by: disposeBag)
        
        deleteCard.connect()
            .disposed(by: disposeBag)
    }

    private func bindView() {
        rootView.tableView.registerClassForCell(MyCardsTableViewCell.self)
        rootView.tableView.separatorStyle = .none
        
        rootView.addCardButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.showAddCardAlert()
        }).disposed(by: disposeBag)
    }
    
    private func showCardAlerAlert(cardId: Int) {
        let alert = UIAlertController(title: "Выберите деиствие", message: nil, preferredStyle: .alert)
        let delete = UIAlertAction(title: "Удалить", style: .destructive) { [unowned self] _ in
            self.removeSubjectId.onNext(cardId)
        }
        let setMain = UIAlertAction(title: "Сделать основной", style: .default) { [unowned self] _ in
            self.setMainSubjectId.onNext(cardId)
        }
        alert.addAction(delete)
        alert.addAction(setMain)
        present(alert, animated: true, completion: nil)
    }
    
    private func showAddCardAlert() {
        // swiftlint:disable line_length
        let alert = UIAlertController(title: "Привязка карты", message: "Для подтверждения банковской карты будет списана сумма от 10 до 50 тенге! Введите название карты:", preferredStyle: .alert)
        alert.addTextField { [unowned self] textField in
            textField.placeholder = "Наименование карты"
            textField.becomeFirstResponder()
            textField.rx.text.bind(to: self.cardName)
                .disposed(by: self.disposeBag)
        }
        alert.addAction(UIAlertAction(title: "Отмена", style: .destructive, handler: nil))
        alert.addAction(.init(title: "Сохранить", style: .default, handler: { [unowned self] _ in
            self.addCard?(alert.textFields?[0].text ?? "")
        }))
        present(alert, animated: true, completion: nil)
    }
    
    override func customBackButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
}
