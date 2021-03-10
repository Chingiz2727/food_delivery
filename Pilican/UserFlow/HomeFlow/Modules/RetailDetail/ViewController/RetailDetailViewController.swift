import RxSwift
import UIKit

final class RetailDetailViewController: ViewController, ViewHolder, RetailDetailModule {
    typealias RootViewType = RetailDetailView

    var presentProblem: Callback?

    private let retail: Retail
    private let workCalendar: WorkCalendar
    private let disposeBag = DisposeBag()

    init(retail: Retail, workCalendar: WorkCalendar) {
        self.retail = retail
        self.workCalendar = workCalendar
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
    }
    
    private func bindView() {
        rootView.setData(retail: retail, workCalendar: workCalendar)
        rootView.faqButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.presentProblem?()
            }).disposed(by: disposeBag)
    }
}
