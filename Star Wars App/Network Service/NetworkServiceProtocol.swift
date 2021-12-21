import Foundation
import Swinject

protocol NetworkServiceProtocol: AnyObject {
    func fetchData<Item: Codable>(from url: String, completion: @escaping (Result<Item, Error>) -> Void)
}
