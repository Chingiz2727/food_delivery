import UIKit

enum SocialNetwork {
    case facebook(String)
    case whatsappUrl(String)
    case telegram(String)
    case youtube(String)
    case instagram(String)
    case webUrl(String)
    case vk(String)
    case phone(String)

    var image: UIImage? {
        switch self {
        case .facebook:
            return Images.facebook.image
        case .whatsappUrl:
            return Images.whatsapp.image
        case .telegram:
            return Images.telegram.image
        case .youtube:
            return Images.youtube.image
        case .webUrl:
            return Images.web.image
        case .vk:
            return Images.vk.image
        case .phone:
            return Images.callCenter.image
        case .instagram:
            return Images.instagram.image
        }
    }
}
