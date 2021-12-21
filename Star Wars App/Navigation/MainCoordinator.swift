import UIKit
import Swinject

enum DefaultNetworkService {
    case none
    case urlSession
    case alamofire
}

class MainCoordinator: Coordinator {
    
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private var networkService: DefaultNetworkService = .none
    private var factory: ItemFactoryProtocol
    
    init(navigationController: UINavigationController, factory: ItemFactoryProtocol) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func start() {
        let viewController = DashboardViewController()
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func presentPersonControllerURLSession() {
        networkService = .urlSession
        let viewController = factory.makeItemViewController(ItemType: Person.self, url: "http://localhost:9000/people/", network: networkService)
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func presentPersonControllerAlamofire() {
        networkService = .alamofire
        let viewController = factory.makeItemViewController(ItemType: Person.self, url: "http://localhost:9000/people/", network: networkService)
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func presentPreLoadedViewController<Item: Codable>(url: String, preLoadedURL: String, itemType: Item.Type) {
        let viewController = factory.makeItemViewController(ItemType: Person.self, url: url, network: networkService)
        viewController.preConfigureViewModel(with: preLoadedURL)
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension MainCoordinator: DashboardViewControllerDelegate {
    func showPersonURLSession() {
        presentPersonControllerURLSession()
    }
    
    func showPersonAlamofire() {
        presentPersonControllerAlamofire()
    }

}

extension MainCoordinator: ItemViewControllerDelegate {
    func showPreLoadedItem(from url: String) {
        
        if url.range(of: "people") != nil {
            presentPreLoadedViewController(url: "http://localhost:9000/people/", preLoadedURL: url, itemType: Person.self)
        } else if url.range(of: "planets") != nil {
            presentPreLoadedViewController(url: "https://swapi.dev/api/planets/", preLoadedURL: url, itemType: Planet.self)
        } else if url.range(of: "films") != nil {
            presentPreLoadedViewController(url: "https://swapi.dev/api/films/", preLoadedURL: url, itemType: Film.self)
        } else if url.range(of: "starships") != nil {
            presentPreLoadedViewController(url: "https://swapi.dev/api/starships/", preLoadedURL: url, itemType: Starship.self)
        } else if url.range(of: "vehicles") != nil {
            presentPreLoadedViewController(url: "https://swapi.dev/api/vehicles/", preLoadedURL: url, itemType: Vehicle.self)
        } else if url.range(of: "species") != nil {
            presentPreLoadedViewController(url: "https://swapi.dev/api/species/", preLoadedURL: url, itemType: Species.self)
        }
    }
}
