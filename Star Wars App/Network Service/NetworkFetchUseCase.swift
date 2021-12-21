import Swinject

protocol NetworkUseCaseProtocol {
    
}

class NetworkFetchUseCase: NetworkUseCaseProtocol {
    var service: NetworkServiceProtocol
    
    init(resolver: Resolver, defaultNetwork: DefaultNetworkService) {
        if defaultNetwork == .alamofire {
            self.service = resolver.resolveUnwrapping(AlamofireNetworkService.self)
        }
        else {
            self.service = resolver.resolveUnwrapping(URLSessionNetworkService.self)
        }
    }
    
    func execute<Item: Codable>(from url: String, completion: @escaping (Result<Item, Error>) -> ()) {
        service.fetchData(from: url, completion: completion)
    }
}
