import Foundation

public enum BiometricAuthType {
    case none
    case touchId
    case faceId
    
    public var title: String? {
        switch self {
        case .faceId:
            return "Face ID"
        case .touchId:
            return "Touch ID"
        case .none:
            return nil
        }
    }
}
