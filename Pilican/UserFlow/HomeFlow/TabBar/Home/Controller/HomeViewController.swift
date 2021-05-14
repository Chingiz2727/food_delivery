import RxSwift
import RxDataSources
import UIKit

class HomeViewController: ViewController, HomeModule, ViewHolder {
    typealias RootViewType = HomeView

    var selectRetail: SelectRetail?
    var selectMenu: SelectMenu?
    private let viewModel: HomeViewModel
    private let dataSource: HomeCollectionViewDataSource
    private let slider = BehaviorSubject<[Slider]>(value: [])
    private let selectedCategory = PublishSubject<Int>()
    private let disposeBag = DisposeBag()

    init(viewModel: HomeViewModel) {
        dataSource = HomeCollectionViewDataSource(slider: slider, categoryMenu: selectedCategory)
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func loadView() {
        view = HomeView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindView()
        bindViewModel()
    }

    private func bindView() {
        rootView.collectionView.registerClassForCell(RetailCollectionViewCell.self)
        rootView.collectionView.registerClassForHeaderView(HomeCollectionViewHeaderView.self)
        rootView.collectionView.registerClassForFooterView(HomeCollectionFooterView.self)
        rootView.searchCollectionView.registerClassForCell(RetailCollectionViewCell.self)
        rootView.layout.headerReferenceSize = .init(width: rootView.collectionView.frame.width, height: 270)
        rootView.layout.footerReferenceSize = .init(width: rootView.collectionView.frame.width, height: 70)
    }

    private func bindViewModel() {
        let output = viewModel.transform(input: .init(viewDidLoad: Observable.merge(.just(()), rootView.rx.retryAction), searchText: rootView.searchBar.rx.text.unwrap()))

        let slider = output.slider.publish()
        let retailList = output.retailList.publish()

        slider.subscribe(onNext: { [unowned self] sliders in
            guard let sliderList = sliders.result?.element else { return }
            self.slider.onNext(sliderList.sliders)
        })
        .disposed(by: disposeBag)
        
        slider.loading
            .bind(to: ProgressView.instance.rx.loading)
            .disposed(by: disposeBag)

        slider.connect()
            .disposed(by: disposeBag)

        retailList.element
            .map { retail in
                [ RetailSection(items: retail.retailList) ]
            }
            .bind(to: rootView.collectionView.rx.items(dataSource: dataSource))
            .disposed(by: disposeBag)

        retailList.loading
            .bind(to: ProgressView.instance.rx.loading)
            .disposed(by: disposeBag)

        retailList.errors
            .bind(to: rootView.rx.error)
            .disposed(by: disposeBag)

        retailList.connect()
            .disposed(by: disposeBag)

        let retailSearchList = output.searchRetailList.publish()
        
        retailSearchList.element.map { $0.retailList }
            .bind(to: rootView.searchCollectionView.rx.items(RetailCollectionViewCell.self)) { _, model, cell  in
                cell.setRetail(retail: model)
            }
            .disposed(by: disposeBag)

        retailSearchList.connect()
            .disposed(by: disposeBag)

        rootView.searchBar.rx.text.unwrap()
            .subscribe(onNext: { [unowned self] text in
                self.rootView.searchCollectionView.isHidden = text.isEmpty
                self.rootView.searchViewBack.isHidden = text.isEmpty
            })
            .disposed(by: disposeBag)
        
        rootView.searchCollectionView.rx.itemSelected
            .withLatestFrom(retailSearchList.element) { $1.retailList[$0.row] }
            .bind { [unowned self] retail in
                self.selectRetail?(retail)
                self.rootView.searchCollectionView.isHidden = true
                self.rootView.searchViewBack.isHidden = true
            }
            .disposed(by: disposeBag)
        
        rootView.collectionView.rx.itemSelected
            .withLatestFrom(retailList.element) { $1.retailList[$0.row] }
            .bind { [unowned self] retail in
                self.selectRetail?(retail)
            }
            .disposed(by: disposeBag)

        selectedCategory.subscribe(onNext: { [unowned self] category in
            self.selectMenu?(HomeCategoryMenu(rawValue: category)!)
        })
        .disposed(by: disposeBag)
    }
}
