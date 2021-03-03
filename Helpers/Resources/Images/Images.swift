import UIKit

enum Images: String {
    case qrCode
    case close
    case Border
    case flash
    case rotate
    case mainqrcode
    case cashback
    case avatar
    case breaking
    case bus
    case group
    case cashbackgroup
    case mainqr
    case checkboxSelected
    case checkboxUnselected
    case instagram
    case facebook
    case vk
    case callCenter
    case youtube
    case web
    case telegram
    case whatsapp
    case payButton
    case deliveryBakcground
    case mapBackground
    case map
    case ArrowCashBack
    case silverLogo
    case gradRectangle
    case Path
}

extension Images {
    var image: UIImage? {
        return UIImage(named: rawValue)
    }
}
