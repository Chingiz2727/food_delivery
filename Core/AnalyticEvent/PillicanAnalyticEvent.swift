
enum PillicanAnalyticEvent: AnalyticsEvent {
    case deliveryMain
    case qrpay
    case partners
    case deliverycafe
    case cafefood
    case deletefood
    case cafepay
    case paydelivery
    case paytakaway
    case cartaddress
    case cartdeletefood
    case cartaddfood
    case cartcomment
    case cartbonus
    case cartpay
    case searchtabbar
    case deliverysearch
    case maptabbar
    case carttabbar
    case maintabbar
    case deliverytabbar
    
    var name: String {
        switch self {
        case .deliveryMain:
            return  "deliveryMain"
        case .qrpay:
            return "qrpay"
        case .partners:
            return "partners"
        case .deliverycafe:
            return "deliverycafe"
        case .cafefood:
            return "cafefood"
        case .cafepay:
            return "cafepay"
        case .paydelivery:
            return "paydelivery"
        case .paytakaway:
            return "paytakaway"
        case .cartaddress:
            return "cartaddress"
        case .cartdeletefood:
            return "cartdeletefood"
        case .cartaddfood:
            return "cartaddfood"
        case .cartcomment:
            return "cartcomment"
        case .cartbonus:
            return "cartbonus"
        case .cartpay:
            return "cartpay"
        case .searchtabbar:
            return "searchtabbar"
        case .deliverysearch:
            return "deliverysearch"
        case .maptabbar:
            return "maptabbar"
        case .carttabbar:
            return "carttabbar"
        case .maintabbar:
            return "maintabbar"
        case .deliverytabbar:
            return "deliverytabbar"
        case .deletefood:
            return "deletefood"
        }
    }
    
    var parameters: [String: String] {
        return [:]
    }
}
