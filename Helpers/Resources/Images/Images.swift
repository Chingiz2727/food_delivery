import UIKit

enum Images: String {
    case qrCode
    case close
}

extension Images {
    var image: UIImage? {
        return UIImage(named: rawValue)
    }
}
