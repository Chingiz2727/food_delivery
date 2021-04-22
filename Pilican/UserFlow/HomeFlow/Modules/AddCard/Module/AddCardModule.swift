protocol AddCardModule: Presentable {
    typealias SendToWebContrroller = (BindCardModel,String) -> Void
    
    var onAddCardTapped: Callback? { get set }
    var sendToWebController: SendToWebContrroller? { get set }
}
