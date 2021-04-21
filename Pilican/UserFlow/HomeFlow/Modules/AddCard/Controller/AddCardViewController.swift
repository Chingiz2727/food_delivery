import UIKit

class AddCardViewController: ViewController, AddCardModule, ViewHolder {

    typealias RootViewType = AddCardView
    var onAddCardTapped: Callback?
    
    private let viewModel: AddCardViewModel
    
    init(viewModel: AddCardViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        nil
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    private func bindViewModel() {
        let output = viewModel.transform(
            input: .init(
                cardName: .just(""),
                holderName: rootView.userNameCardTextField.cardText,
                cardNumber: rootView.scancardTextField.cardText,
                cvv: rootView.cvcTextField.cardText,
                date: rootView.dateTextField.cardText,
                addTapped: rootView.addCardButton.rx.tap.asObservable()))
        
    }
}
