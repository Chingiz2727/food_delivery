import RxSwift
import UIKit

final class RetailDetailViewController: ViewController, ViewHolder, RetailDetailModule {
    var retailDetailTapped: RetailDetailTapped?
    
    typealias RootViewType = RetailDetailView

    var presentProblem: Callback?

    private let retail: Retail
    private let workCalendar: WorkCalendar
    private let disposeBag = DisposeBag()
    private let dishList: DishList

    init(retail: Retail, workCalendar: WorkCalendar, dishList: DishList) {
        self.retail = retail
        self.workCalendar = workCalendar
        self.dishList = dishList
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func loadView() {
        view = RetailDetailView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        title = retail.name
    }

    override func customBackButtonDidTap() {
        navigationController?.popViewController(animated: true)
    }
    
    override func customCloseButtonDidTap() {
        
    }
    
    private func bindView() {
        rootView.setData(retail: retail, workCalendar: workCalendar)
        rootView.faqButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.presentProblem?()
            }).disposed(by: disposeBag)
        rootView.identificatorView.payControl.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                self.retailDetailTapped?(.pay)
                print("pay")
            }).disposed(by: disposeBag)
        rootView.deliveryView.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                print("del")
                if retail.isWork == 1 {
                    if retail.id != dishList.retail?.id && !dishList.products.isEmpty {
                        showBasketAlert {
                            self.dishList.products = []
                            self.dishList.wishDishList.onNext([])
                            self.retailDetailTapped?(.delivery)
                        }
                    } else {
                        self.retailDetailTapped?(.delivery)
                    }
                }
            }).disposed(by: disposeBag)
        rootView.showMap.rx.controlEvent(.touchUpInside)
            .subscribe(onNext: { [unowned self] in
                self.retailDetailTapped?(.map)
                print("map")
            }).disposed(by: disposeBag)
    }
}
