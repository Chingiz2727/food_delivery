public struct BindCardModel: Codable {
    public let status: Int?
    public let needConfirmation: Bool?
    public let paReq: String?
    public let acsUrl: String?
    public let mD : Int?
    public let termUrl: String?
    public let threeDsCallbackId: String?
}
