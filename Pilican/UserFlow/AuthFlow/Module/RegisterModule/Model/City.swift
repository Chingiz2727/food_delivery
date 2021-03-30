public struct City: Codable {
    public let id: Int
    public let name: String
}

public struct CityList: Codable {
    public let cities: [City]
}
