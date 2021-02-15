struct City: Codable {
    let id: Int
    let name: String
}

struct CityList: Codable {
    let cities: [City]
}
