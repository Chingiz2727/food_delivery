struct RetailCategory: Codable {
    let id: Int
    let name: String
    let status: Int
    let parent: [RetailCategory]?
}
