import UIKit

class RetailSearchViewController: UIViewController, RetailSearchModule, ViewHolder {
    
    typealias RootViewType = RetailSearchView
    
    var onSearchTap: OnSearchTap?

    override func loadView() {
        view = RetailSearchView()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
