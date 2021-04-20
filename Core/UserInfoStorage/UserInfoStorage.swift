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
    
    @UserDefaultsEntry("birthday", defaultValue: nil)
    public var birthday: String?
    
    @UserDefaultsEntry("gender", defaultValue: nil)
    public var gender: Bool?
    
    @UserDefaultsEntry("deliveryLocation", defaultValue: [])
    public var location: [DeliveryLocation]
    
    public init() {}

    public func clearAll() {
        fullName = ""
        mobilePhoneNumber = ""
        city = ""
        lastName = ""
        promoCode = ""
        balance = 0
        mobilePhoneNumber = ""
        cityId = 0
        birthday = ""
        gender = false
        location = []
    }
}
