import UIKit

protocol SwipeableTableViewCellDelegate: class {
    func visibleContainerViewTapped(inCell cell: UITableViewCell)
    func hiddenContainerViewTapped(inCell cell: UITableViewCell)
}
