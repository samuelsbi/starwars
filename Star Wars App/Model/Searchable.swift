import Foundation
protocol Searchable {
    static var group: String {get}
    static func url() -> String
}

extension Searchable where Self: Codable {
    static func url() -> String{
        return "https://swapi.dev/api/\(group)/"
    }
}
