import UIKit
import RxSwift

public extension UICollectionView {

  func registerClassForCell(_ cellClass: UICollectionViewCell.Type) {
    register(cellClass, forCellWithReuseIdentifier: cellClass.reuseIdentifier)
  }

  func registerClassesForCells(_ cellClasses: UICollectionViewCell.Type...) {
    for cellClass in cellClasses {
      registerClassForCell(cellClass)
    }
  }

  func dequeueReusableCell<T: UICollectionViewCell>(for indexPath: IndexPath) -> T {
    guard let cell = dequeueReusableCell(
      withReuseIdentifier: T.self.reuseIdentifier,
      for: indexPath) as? T else {
        fatalError("You are trying to dequeue \(T.self) which is not registered")
    }
    return cell
  }

  func registerClassForSupplementaryView(_ viewClass: UICollectionReusableView.Type, ofKind kind: String) {
    register(
      viewClass,
      forSupplementaryViewOfKind: kind,
      withReuseIdentifier: viewClass.reuseIdentifier
    )
  }

  func dequeueReusableSupplementaryView<T: UICollectionReusableView>(
    ofKind kind: String,
    for indexPath: IndexPath
  ) -> T {
    guard let view = dequeueReusableSupplementaryView(
      ofKind: kind,
      withReuseIdentifier: T.self.reuseIdentifier,
      for: indexPath) as? T else {
        fatalError("You are trying to dequeue \(T.self) which is not registered")
    }
    return view
  }

  func registerClassForHeaderView(_ viewClass: UICollectionReusableView.Type) {
    registerClassForSupplementaryView(viewClass, ofKind: UICollectionView.elementKindSectionHeader)
  }

  func dequeueReusableHeaderView<T: UICollectionReusableView>(for indexPath: IndexPath) -> T {
    dequeueReusableSupplementaryView(
      ofKind: UICollectionView.elementKindSectionHeader,
      for: indexPath
    )
  }

  func registerClassForFooterView(_ viewClass: UICollectionReusableView.Type) {
    registerClassForSupplementaryView(viewClass, ofKind: UICollectionView.elementKindSectionFooter)
  }

  func dequeueReusableFooterView<T: UICollectionReusableView>(for indexPath: IndexPath) -> T {
    dequeueReusableSupplementaryView(
      ofKind: UICollectionView.elementKindSectionFooter,
      for: indexPath
    )
  }
}

public extension Reactive where Base: UICollectionView {

  // swiftlint:disable all
  func items<Sequence: Swift.Sequence, Cell: UICollectionViewCell, Source: ObservableType>
    (_ cellClass: Cell.Type)
    -> (_ source: Source)
    -> (_ configureCell: @escaping (Int, Sequence.Element, Cell) -> Void)
    -> Disposable where Source.Element == Sequence {
      return base.rx.items(cellIdentifier: cellClass.reuseIdentifier, cellType: cellClass)
  }
}
