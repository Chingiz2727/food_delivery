import LocalAuthentication

public final class BiometricAuthService {
    public var type: BiometricAuthType {
        if #available(iOS 11.0.1, *) {
            _ = context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil)
            switch context.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touchId
            case .faceID:
                return .faceId
            @unknown default:
                return .none
            }
        } else {
            return context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchId : .none
        }
    }

    private lazy var context = LAContext()

    public init() {}

    public func canAuthenticate() -> Bool {
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            return error == nil
        }
        return false
    }
    
    public func authenticate(reason: String, completion: @escaping(Result<Bool>)->Void){
        self.context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { (isAuthed, error) in
            if error != nil {
                completion(.error(error!))
            } else {
                completion(.success(isAuthed))
            }
        }
    }
}
