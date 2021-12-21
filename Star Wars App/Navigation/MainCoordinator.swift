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
        let viewController = factory.makeItemViewController(ItemType: Person.self, network: networkService)
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func presentPersonControllerAlamofire() {
        networkService = .alamofire
        let viewController = factory.makeItemViewController(ItemType: Person.self, network: networkService)
        viewController.delegate = self
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func presentPreLoadedViewController<Item: Codable & Searchable>(preLoadedURL: String, itemType: Item.Type) {
        //let url = "https://swapi.dev/api/\(name)/"
        let viewController = factory.makeItemViewController(ItemType: Item.self, network: networkService)
        viewController.delegate = self
        viewController.preConfigureViewModel(with: preLoadedURL)
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
            presentPreLoadedViewController(preLoadedURL: url, itemType: Person.self)
        } else if url.range(of: "planets") != nil {
            presentPreLoadedViewController(preLoadedURL: url, itemType: Planet.self)
        } else if url.range(of: "films") != nil {
            presentPreLoadedViewController(preLoadedURL: url, itemType: Film.self)
        } else if url.range(of: "starships") != nil {
            presentPreLoadedViewController(preLoadedURL: url, itemType: Starship.self)
        } else if url.range(of: "vehicles") != nil {
            presentPreLoadedViewController(preLoadedURL: url, itemType: Vehicle.self)
        } else if url.range(of: "species") != nil {
            presentPreLoadedViewController(preLoadedURL: url, itemType: Species.self)
        }
    }
}
