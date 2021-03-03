import RxSwift
import UIKit
import Foundation

final class WorkTimeView: UIView {
    private let headerView = WorkTimeHeaderView()
    private let disposeBag = DisposeBag()
    private lazy var workDayStackView = UIStackView(
        views: [headerView, workDayListStackView],
        axis: .vertical,
        spacing: 10)

    private lazy var workDayListStackView = UIStackView(
        views: [],
        axis: .vertical,
        distribution: .equalSpacing,
        spacing: 2)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        nil
    }

    func setupData(workDay: [WorkDay], workCalendar: WorkCalendar) {
        let currentWorkDay = workDay.filter { $0.day == workCalendar.currenDayNumber }.first
        guard let currentDay = currentWorkDay else { return }
        headerView.setupData(workDay: currentDay)
        setupDaysView(workDay: workDay)
    }

    private func setupInitialLayout() {
        addSubview(workDayStackView)
        workDayStackView.snp.makeConstraints { $0.edges.equalToSuperview().inset(2) }
        headerView.setupAsHeaderInitialLayout()
        headerView.snp.makeConstraints { $0.height.equalTo(40) }
    }

    private func configureView() {
        headerView.expandButton.isHidden = false
        workDayListStackView.isHidden = true
        backgroundColor = .pilicanWhite
        headerView.expandButton.rx.tap
            .subscribe(onNext: { [unowned self] in
                self.makeAnimation()
            })
            .disposed(by: disposeBag)
    }

    private func setupDaysView(workDay: [WorkDay]) {
        workDay.forEach { [unowned self] work in
            let view = WorkTimeHeaderView()
            view.setupData(workDay: work)
            view.setupDetailInitialLayout()
            view.snp.makeConstraints { $0.height.equalTo(25) }
            workDayListStackView.addArrangedSubview(view)
        }
    }

    private func makeAnimation() {
        UIView.animate(withDuration: 0.3, animations: { [unowned self] in
            self.workDayListStackView.isHidden = !self.workDayListStackView.isHidden
        })
    }
}
