public final class UserInfoStorage {
    @UserDefaultsEntry("firstName", defaultValue: nil)
    public var fullName: String?

    @UserDefaultsEntry("mobilePhoneNumber", defaultValue: nil)
    public var mobilePhoneNumber: String?
    
    @UserDefaultsEntry("balance", defaultValue: 0)
    public var balance: Int?
    
    @UserDefaultsEntry("promoCode", defaultValue: nil)
    public var promoCode: String?
    
    @UserDefaultsEntry("lastName", defaultValue: nil)
    public var lastName: String?

    @UserDefaultsEntry("city", defaultValue: nil)
    public var city: String?
    
    @UserDefaultsEntry("cityId", defaultValue: nil)
    public var cityId: Int?
    
    public init() {}

    public func clearAll() {
        fullName = nil
        mobilePhoneNumber = nil
        city = nil
        lastName = nil
        promoCode = nil
        balance = nil
        mobilePhoneNumber = nil
        cityId = nil
    }
}
