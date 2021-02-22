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
}

extension Images {
    var image: UIImage? {
        return UIImage(named: rawValue)
    }
}
