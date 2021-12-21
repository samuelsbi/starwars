import Foundation

class URLSessionNetworkService: NetworkServiceProtocol {
    
    func fetchData<Item: Codable>(from url: String, completion: @escaping (Result<Item, Error>) -> Void) {
        
        guard let url = URL(string: url) else {
            let error = NSError(domain: "", code: 401, userInfo: [NSLocalizedDescriptionKey: "URL is invalid, please try again"])
            completion(.failure(error))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
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
            
        }.resume()
    }
}
