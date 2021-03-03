import UIKit

final class RetailDetailView: UIView {
    private let scrollView = UIScrollView()
    private let emptyView = UIView()
    private let sliderView = ImageSlideshow()
    private let headerView = RetailDetailHeaderView()
    private let socialLinkView = SocialLinksView()
    private let deliveryView = DeliveryView()
    private let identificatorView = IdentificatorView()
    private let showMap = ShowMapViewUIControl()
    private let cashBackView = CashBackView()
    private let workView = WorkTimeView()
    private let retailDescriptionView = RetailDescriptionView()
    
    let faqButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = #colorLiteral(red: 0.9568627451, green: 0.262745098, blue: 0.2117647059, alpha: 1)
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .description1
        button.setTitle("Что-то не так? Сообщите нам", for: .normal)
        button.setTitleColor(.pilicanWhite, for: .normal)
        return button
    }()

    private lazy var stackView = UIStackView(
        views: [
            headerView,
            socialLinkView,
            deliveryPayStackView,
            showMap,
            cashBackView,
            workView,
            retailDescriptionView,
            faqButton,
            emptyView
        ],
        axis: .vertical,
        spacing: 15
    )

    private lazy var deliveryPayStackView = UIStackView(
        views: [identificatorView, deliveryView],
        axis: .horizontal,
        distribution: .fillEqually,
        spacing: 10)

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupInitialLayout()
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func setData(retail: Retail, workCalendar: WorkCalendar) {
        headerView.setRetail(retail: retail)
        socialLinkView.setup(links: retail.networkList)
        workView.setupData(workDay: retail.workDays, workCalendar: workCalendar)
        retailDescriptionView.setupData(retail: retail)
    }

    private func setupInitialLayout() {
        addSubview(scrollView)

        scrollView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        scrollView.addSubview(sliderView)
        scrollView.addSubview(stackView)

        sliderView.snp.makeConstraints { make in
            make.top.leading.width.trailing.equalToSuperview()
            make.height.equalTo(286)
        }

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(241)
            make.bottom.equalToSuperview().inset(20)
            make.leading.trailing.width.equalTo(self).inset(8)
        }
        
        emptyView.snp.makeConstraints { $0.height.equalTo(40) }
        stackView.snp.makeConstraints { $0.edges.equalToSuperview().inset(10) }
        headerView.snp.makeConstraints { $0.height.equalTo(90) }
        socialLinkView.snp.makeConstraints { $0.height.equalTo(50) }
        deliveryPayStackView.snp.makeConstraints { $0.height.equalTo(50) }
        showMap.snp.makeConstraints { $0.height.equalTo(50) }
        cashBackView.snp.makeConstraints { $0.height.equalTo(60) }
        faqButton.snp.makeConstraints { $0.height.equalTo(40) }
    }

    private func configureView() {
        scrollView.bounces = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        backgroundColor = .background
    }
}
