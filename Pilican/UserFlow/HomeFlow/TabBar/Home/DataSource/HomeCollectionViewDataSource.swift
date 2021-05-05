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
        }, configureSupplementaryView: { _, collectionview, _, index in
            let disposeBag = DisposeBag()
            let header: HomeCollectionViewHeaderView = collectionview.dequeueReusableHeaderView(for: index)
            slider.subscribe(onNext: { sliders in
                header.setupSlider(sliders: sliders)
            }).disposed(by: disposeBag)
            header.showTag = { tag in
                categoryMenu.onNext(tag)
            }
            return header
        })
    }
}
