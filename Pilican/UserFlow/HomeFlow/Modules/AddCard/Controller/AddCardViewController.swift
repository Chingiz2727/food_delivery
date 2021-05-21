import RxSwift
import UIKit

#if canImport(CardScanner)
import CardScanner
#endif
class AddCardViewController: ViewController, AddCardModule, ViewHolder {
    
    typealias RootViewType = AddCardView
    var onAddCardTapped: Callback?
    var sendToWebController: SendToWebContrroller?
    var showCardStatus: ShowAddCardStatus?
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
        title = "Добавление карты"
        navigationController?.navigationBar.isHidden = false
        addCustomizedNotifyBar()
        bindViewModel()
        binvdView()
    }
    
    private func bindViewModel() {
        let output = viewModel.transform(
            input: .init(
                holderName: rootView.userNameCardTextField.cardText,
                cardNumber: rootView.scancardTextField.cardText,
                cvv: rootView.cvcTextField.cardText,
                date: rootView.dateTextField.cardText,
                addTapped: rootView.addCardButton.rx.tap.asObservable(),
                makeCryptogram: bindCardSubject))
        
        let bindCardModel = output.makeCryptogram.publish()
        
        bindCardModel.element.subscribe(onNext: { [unowned self] model in
            if model.needConfirmation == true {
                ProgressView.instance.show(.loading, animated: true)
                MoyaApiService.shared.pass3DSecure(url: model.acsUrl!, model: model, token: self.viewModel.sessionStorage.accessToken ?? "") { (html, error) in
                    if let error = error {
                        self.showErrorInAlert(text: error.localizedDescription)
                    } else {
                        if let html = html {
                            self.sendToWebController?(model,html)
                        } else {
                            self.showCardStatus?(.failure)
                        }
                    }
                    ProgressView.instance.hide()
                }
            } else {
                self.showCardStatus?(.succes)
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
        
        
    }
    
    private func binvdView() {
        let filled = [
            rootView.userNameCardTextField.isFilled,
            rootView.scancardTextField.isFilled,
            rootView.cvcTextField.isFilled,
            rootView.dateTextField.isFilled]
        
        Observable.combineLatest(filled.map { $0 }) { $0.allSatisfy { $0 }}
            .distinctUntilChanged()
            .bind(to: rootView.addCardButton.rx.isEnabled)
            .disposed(by: disposeBag)

        rootView.scancardTextField.scanButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.showCardScanner()
            })
            .disposed(by: disposeBag)
    }
    
    private func showCardScanner() {
        if #available(iOS 13.0, *) {
            let scannerView = CardScanner.getScanner { [unowned self] card, date, cvv in
                print(card)
                self.rootView.scancardTextField.setValue(text: card ?? "")
                self.rootView.dateTextField.setValue(text: date ?? "")
                self.rootView.cvcTextField.setValue(text: cvv ?? "")
            }
            self.present(scannerView, animated: true, completion: nil)
        } else {
            // Fallback on earlier versions
        }
    }
    
    override func customBackButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
}
