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
    case accountImage
    case accountEdit
    case accountCard
    case accountKey
    case accountPassword
    case accountQR
    case confetti
    case girl
    case knife
    case shoppingCart
    case filledStar
    case emptyStar
    case card
    case deleteCardButton
    case selectedCardButton
    case pillikanLogo
    case sloganLogo
    case volunteer
    case copyButton
    case balanceCard
    case successPaymentBackground
    case minus
    case plus
    case accept
    case decline
    case delivery
    case fillStar
    case arrow
    case takeAway
    case inPlace
    case deliveryType
    case arrowGray
    case search
    case SearchSelected
    case searchDelivery
    case basket
    case basketSelected
}

extension Images {
    var image: UIImage? {
        return UIImage(named: rawValue)
    }
}
