import Foundation

extension NSObject {

  func deepCopy<T>() -> T {
    let data = NSKeyedArchiver.archivedData(withRootObject: self)
    guard let copy = NSKeyedUnarchiver.unarchiveObject(with: data) as? T else {
      fatalError("Can't cast copy to \(T.self)")
    }

    return copy
  }
}
