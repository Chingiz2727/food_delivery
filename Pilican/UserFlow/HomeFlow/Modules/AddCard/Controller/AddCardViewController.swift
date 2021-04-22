import RxSwift

import UIKit

class AddCardViewController: ViewController, AddCardModule, ViewHolder {

    typealias RootViewType = AddCardView
    var onAddCardTapped: Callback?
    var sendToWebController: SendToWebContrroller?
    private let viewModel: AddCardViewModel
    private let disposeBag = DisposeBag()
    private let bindCardSubject = PublishSubject<BindCardModel>()
    override func loadView() {
        view = AddCardView()
    }
    
    init(viewModel: AddCardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }

    private func bindViewModel() {
        let output = viewModel.transform(
            input: .init(
                cardName: .just("Shyngyscard"),
                holderName: rootView.userNameCardTextField.cardText,
                cardNumber: rootView.scancardTextField.cardText,
                cvv: rootView.cvcTextField.cardText,
                date: rootView.dateTextField.cardText,
                addTapped: rootView.addCardButton.rx.tap.asObservable(),
                makeCryptogram: bindCardSubject))
        
        let bindCardModel = output.makeCryptogram.publish()
        
        bindCardModel.element.subscribe(onNext: { [unowned self] model in
            if model.needConfirmation == true {
                MoyaApiService.shared.pass3DSecure(url: model.acsUrl!, model: model, token: self.viewModel.sessionStorage.accessToken ?? "") { (html, error) in
                    if let html = html {
                        self.sendToWebController?(model,html)
                    } else {
                        self.showErrorInAlert(text: error?.localizedDescription ?? "")
                    }
                }
            }
        })
        .disposed(by: disposeBag)
        
        bindCardModel.loading
            .bind(to: ProgressView.instance.rx.loading)
            .disposed(by: disposeBag)
        
        bindCardModel.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)
        
        bindCardModel.connect()
            .disposed(by: disposeBag)
        
        let need3ds = output.need3ds.publish()
        need3ds.element.subscribe(onNext: { [unowned self] model in
           print(model)
        })
        .disposed(by: disposeBag)
        need3ds.loading
            .bind(to: ProgressView.instance.rx.loading)
            .disposed(by: disposeBag)
        
        need3ds.errors
            .bind(to: rx.error)
            .disposed(by: disposeBag)
        
        need3ds.connect()
            .disposed(by: disposeBag)
        
        let filled = [
            rootView.userNameCardTextField.isFilled,
            rootView.scancardTextField.isFilled,
            rootView.cvcTextField.isFilled,
            rootView.dateTextField.isFilled]
        
        Observable.combineLatest(filled.map { $0 }) { $0.allSatisfy { $0 }}
            .distinctUntilChanged()
            .bind(to: rootView.addCardButton.rx.isEnabled)
            .disposed(by: disposeBag)
    }
}
