import UIKit

protocol SwipeableCollectionViewCellDelegate: class {
    func visibleContainerViewTapped(inCell cell: UICollectionViewCell)
    func hiddenContainerViewTapped(inCell cell: UICollectionViewCell)
}
