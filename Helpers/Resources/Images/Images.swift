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
    case rateDelivery
    case rateMeal
    case ugly
    case bad
    case middle
    case good
    case cool
    case search
    case SearchSelected
    case searchDelivery
    case basket
    case basketSelected
    case alarm
    case pillikanInfo
    case pillikanPay
    case action
    case Location
    case LocationSelected
    case homeDelivery
    case homeDeliverySelected
    case mapIcon
    case minusDelivery
    case plusDelivery
    case comment
    case checkD
    case tenge
    case placeholder
    case qr
    case moji
    case taxi
    case pillikanDelivery
    case contactlessDellivery
    case scooter
    case deliveryMenu
    case correctCircle
    case correct
    case quit
    case orderSuccess
    case orderError
    case attentionAlcohol
    case scanIcon
    case HomePillikanSelected
    case cooking
    case delivered
    case orderAccepted
    case orderCooking
    case orderDelivered
    case orderSent
    case sent
}

extension Images {
    var image: UIImage? {
        return UIImage(named: rawValue)
    }
}
