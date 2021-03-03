import RxSwift
import RxDataSources
import UIKit

class HomeViewController: ViewController, HomeModule, ViewHolder {
    typealias RootViewType = HomeView

    var selectRetail: SelectRetail?
    private let viewModel: HomeViewModel
    private let dataSource: HomeCollectionViewDataSource
    private let slider = BehaviorSubject<[Slider]>(value: [])
    private let disposeBag = DisposeBag()
    init(viewModel: HomeViewModel) {
        dataSource = HomeCollectionViewDataSource(slider: slider)
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
        rootView.collectionView.registerClassForHeaderView(HomeTableVIewHeaderView.self)
        rootView.layout.headerReferenceSize = .init(width: rootView.collectionView.frame.width, height: 270)
    }

    private func bindViewModel() {
        let output = viewModel.transform(input: .init(viewDidLoad: Observable.merge(.just(()))))

        let slider = output.slider.publish()
        let retailList = output.retailList.publish()

        slider.subscribe(onNext: { [unowned self] sliders in
            guard let sliderList = sliders.result?.element else { return }
            self.slider.onNext(sliderList.sliders)
        })
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
            .bind(to: rx.error)
            .disposed(by: disposeBag)

        retailList.connect()
            .disposed(by: disposeBag)

        rootView.collectionView.rx.itemSelected
            .withLatestFrom(retailList.element) { $1.retailList[$0.row] }
            .bind { [unowned self] retail in
                self.selectRetail?(retail)
            }
            .disposed(by: disposeBag)
    }
}
