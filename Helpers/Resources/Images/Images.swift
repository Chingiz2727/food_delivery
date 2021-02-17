import UIKit

enum Images: String {
    case qrCode
    case close
    case Border
    case flash
    case rotate
}

extension Images {
    var image: UIImage? {
        return UIImage(named: rawValue)
    }
}
