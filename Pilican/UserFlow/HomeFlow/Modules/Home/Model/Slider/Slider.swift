struct Sliders: Codable {
    let sliders: [Sliders]
}

struct Slider: Codable {
    let title: String
    let image: String
    let url: String
    let retailId: Int
    let type: Int
}
