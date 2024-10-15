struct MenuItem: Decodable, Identifiable {
    let id: Int
    let title: String
    let description: String
    let image: String
    let price: String
}
