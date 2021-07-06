public struct DeliveryLocation: Codable {
    public let point: MapPoint
    public let name: String
}

struct DeliveryLocationArea: Codable {
    let area: Area
}

struct Area: Codable {
    let id: Int
    let cityId: Int
    let params: AreaParams
}

struct AreaParams: Codable {
    let coordinates: [[[Double]]]
    let type: String
}
