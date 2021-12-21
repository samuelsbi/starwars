import Alamofire
import Foundation

class AlamofireNetworkService: NetworkServiceProtocol {
    
    func fetchData<Item: Codable>(from url: String, completion: @escaping (Swift.Result<Item, Error>) -> Void) {
        Alamofire.request(url).validate().responseJSON{ response in
            if let error = response.error {
                completion(.failure(error))
                return
            }
            guard let data = response.data else {
                let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "Could not unwrap data somehow"])
                completion(.failure(error))
                return
            }
            do {
                let item = try JSONDecoder().decode(Item.self, from: data)
                completion(.success(item))
            } catch {
                completion(.failure(error))
            }
        }
    }
}
