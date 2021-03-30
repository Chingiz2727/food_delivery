import Foundation

@propertyWrapper
public struct UserDefaultsOptionalEntry<T> {
    public var wrappedValue: T? {
        get {
            userDefaults.object(forKey: key) as? T
        }
        set {
            userDefaults.set(newValue, forKey: key)
        }
    }

    private let key: String
    private let userDefaults: UserDefaults

    public init(_ key: String, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.userDefaults = userDefaults
    }
}

@propertyWrapper
public struct UserDefaultsOptionalEnumEntry<Enum: RawRepresentable> {
    public var wrappedValue: Enum? {
        get { getWrappedValue() }
        set { updateWrappedValue(newValue) }
    }

    private let key: String
    private let defaultValue: Enum?

    public init(_ key: String, defaultValue: Enum? = nil) {
        self.key = key
        self.defaultValue = defaultValue
    }

    private func getWrappedValue() -> Enum? {
        if let rawValue = UserDefaults.standard.object(forKey: key) as? Enum.RawValue {
            return Enum(rawValue: rawValue) ?? defaultValue
        } else {
            return defaultValue
        }
    }

    private func updateWrappedValue(_ newValue: Enum?) {
        if let newValue = newValue {
            UserDefaults.standard.set(newValue.rawValue, forKey: key)
        } else {
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
}

@propertyWrapper
public struct UserDefaultsEntry<T> {
    public var wrappedValue: T {
        get {
            userDefaults.object(forKey: key) as? T ?? defaultValue
        }
        set {
            userDefaults.set(newValue, forKey: key)
        }
    }

    private let key: String
    private let defaultValue: T
    private let userDefaults: UserDefaults

    public init(_ key: String, defaultValue: T, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }
}

public struct UserDefaultsStorage {}
