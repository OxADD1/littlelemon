import Foundation

struct MenuItem: Decodable, Identifiable {
    var id = UUID()
    let title: String
    let image: String
    let price: String
}
