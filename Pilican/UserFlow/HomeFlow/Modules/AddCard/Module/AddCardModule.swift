protocol AddCardModule: Presentable {
    typealias SendToWebContrroller = (BindCardModel,String) -> Void
    typealias ShowAddCardStatus = (Status) -> Void
    var onAddCardTapped: Callback? { get set }
    var showCardStatus: ShowAddCardStatus? { get set }
    var sendToWebController: SendToWebContrroller? { get set }
}
