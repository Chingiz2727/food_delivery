import UIKit

public protocol SearchImage where Self: UIViewController {
    
    var backgroundImageView: UIImageView { get }
    var blurEffectView: UIView { get }
}

open class SearchViewController: UIViewController, ViewHolder, SearchImage {
    
    public typealias RootViewType = SearchView
    
    public var backgroundImageView: UIImageView {
        rootView.backgroundImageView
    }
    
    public var blurEffectView: UIView {
        rootView.blurEffectView
    }
    
    private let transitionManager = SearchTransitionManager()
    
    open override func loadView() {
        view = SearchView()
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
}
