struct CardList: Codable {
    let cards: [MyCard]
    let balance: Int
}

// MARK: - Card
struct MyCard: Codable {
    let cardHash: String
    let id, isMain: Int
    let name, createdAt: String
}
