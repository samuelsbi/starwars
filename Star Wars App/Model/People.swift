import Foundation

struct People: Codable {
    let count: Int
    let next: String?
    let previous: String?
    let results: [Person]
}
