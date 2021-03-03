import UIKit

final class RetailDetailViewController: ViewController, ViewHolder, RetailDetailModule {
    typealias RootViewType = RetailDetailView
    
    private let retail: Retail
    private let workCalendar: WorkCalendar

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
        rootView.setData(retail: retail, workCalendar: workCalendar)
    }
}
