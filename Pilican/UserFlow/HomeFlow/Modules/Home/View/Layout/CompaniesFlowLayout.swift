import UIKit

final class CompaniesFlowLayout: UICollectionViewFlowLayout {
    
    override func prepare() {
        guard let collection = collectionView else { return }
        itemSize = .init(width: collection.frame.width - 32, height: 90)
        minimumLineSpacing = 10
        minimumInteritemSpacing = 10
    }
}
