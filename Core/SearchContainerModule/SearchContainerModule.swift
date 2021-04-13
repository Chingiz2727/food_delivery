import UIKit

public protocol SearchContainerModule {

  typealias SearchTapCompletion = () -> Void

  func addSearch(onTap: @escaping SearchTapCompletion)
}

public extension SearchContainerModule where Self: UIViewController {

  func addSearch(onTap: @escaping SearchTapCompletion) {
    addSearchToNavigationBar(action: onTap)
  }
}
