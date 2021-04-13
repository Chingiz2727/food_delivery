enum NotificationsList: String, CaseIterable {
    case pillikanInfo
    case pillikanPay
    
    var img: String {
        switch self {
        case .pillikanInfo:
            return Images.pillikanInfo.rawValue
        case .pillikanPay:
            return Images.pillikanPay.rawValue
        @unknown default:
            return ""
        }
    }
    
    var titleText: String {
        switch self {
        case .pillikanInfo:
            return "Pillikan Info"
        case .pillikanPay:
            return "Pillikan Pay"
        @unknown default:
            return ""
        }
    }
    
    var descriptionText: String {
        switch self {
        case .pillikanInfo:
            return "Системные уведомления"
        case .pillikanPay:
            return "Уведомления об оплате"
        @unknown default:
            return ""
        }
    }
}
