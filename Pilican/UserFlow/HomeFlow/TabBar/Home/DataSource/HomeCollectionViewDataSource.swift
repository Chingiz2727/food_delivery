import UIKit
import RxSwift
import RxDataSources

final class HomeCollectionViewDataSource: RxCollectionViewSectionedReloadDataSource<RetailSection> {

    private let slider: BehaviorSubject<[Slider]>
    init(slider: BehaviorSubject<[Slider]>, categoryMenu: PublishSubject<Int>) {
        self.slider = slider
        super.init(configureCell: { _, collectionview, index, model  in
            let cell: RetailCollectionViewCell = collectionview.dequeueReusableCell(for: index)
            cell.setRetail(retail: model)
            return cell
        }, configureSupplementaryView: { _, collectionview, kind, index in
            let disposeBag = DisposeBag()
            let header: HomeCollectionViewHeaderView = collectionview.dequeueReusableHeaderView(for: index)
            let footer: HomeCollectionFooterView = collectionview.dequeueReusableFooterView(for: index)
            slider.subscribe(onNext: { sliders in
                header.setupSlider(sliders: sliders)
            }).disposed(by: disposeBag)
            header.showTag = { tag in
                categoryMenu.onNext(tag)
            }
            footer.tapAction = {
                categoryMenu.onNext(0)
            }
            footer.button.isUserInteractionEnabled = true
            footer.isUserInteractionEnabled = true
            switch kind {
            case UICollectionView.elementKindSectionHeader:
                return header
            case UICollectionView.elementKindSectionFooter:
                return footer
            default:
                break
            }
            return UICollectionReusableView()
        })
    }
}
