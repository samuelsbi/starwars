//
//  Assembly.swift
//  Star Wars App
//
//  Created by Samuel Brasileiro dos Santos Neto on 14/12/21.
//

import Swinject
import UIKit

class ItemsAssemble: Assembly {
    
    public func assemble(container: Container) {
        // MARK: - NAVIGATION
        container.register(Coordinator.self){ (resolver: Resolver, navigationController: UINavigationController) -> MainCoordinator in
            let factory = resolver.resolveUnwrapping(ItemFactoryProtocol.self)
            return MainCoordinator(navigationController: navigationController, factory: factory)
        }
        
        // MARK: - FACTORY
        container.register(ItemFactoryProtocol.self) { (resolver: Resolver) -> ItemFactory in
            return ItemFactory(resolver: resolver)
        }
        
        // MARK: - DASHBOARD
        container.register(DashboardViewController.self) { (resolver: Resolver) -> DashboardViewController in
            return DashboardViewController()
        }
        
        // MARK: - NETWORK
        container.register(AlamofireNetworkService.self) { (resolver: Resolver) -> AlamofireNetworkService in
            return AlamofireNetworkService()
        }
        container.register(URLSessionNetworkService.self) { (resolver: Resolver) -> URLSessionNetworkService in
            return URLSessionNetworkService()
        }
        
        container.register(NetworkFetchUseCase.self) { (resolver: Resolver, defaultNetwork: DefaultNetworkService) -> NetworkFetchUseCase in
            return NetworkFetchUseCase(resolver: resolver, defaultNetwork: defaultNetwork)
        }
        
        registerViewModels(container: container)
        registerItemsViewControllers(container: container)
    }
    
    private func registerViewModels(container: Container) {
        container.register(ItemViewModel.self) { (resolver: Resolver, defaultNetwork: DefaultNetworkService) -> ItemViewModel<Person> in
            let networkUseCase = resolver.resolveUnwrapping(NetworkFetchUseCase.self, argument: defaultNetwork)
            let url = "https://swapi.dev/api/\(Person.group)/"
            return ItemViewModel(networkUseCase: networkUseCase)
        }
        
        container.register(ItemViewModel.self) { (resolver: Resolver, defaultNetwork: DefaultNetworkService) -> ItemViewModel<Planet> in
            let networkUseCase = resolver.resolveUnwrapping(NetworkFetchUseCase.self, argument: defaultNetwork)
            return ItemViewModel(networkUseCase: networkUseCase)
        }
        
        container.register(ItemViewModel.self) { (resolver: Resolver, defaultNetwork: DefaultNetworkService) -> ItemViewModel<Film> in
            let networkUseCase = resolver.resolveUnwrapping(NetworkFetchUseCase.self, argument: defaultNetwork)
            return ItemViewModel(networkUseCase: networkUseCase)
        }
        
        container.register(ItemViewModel.self) { (resolver: Resolver, defaultNetwork: DefaultNetworkService) -> ItemViewModel<Starship> in
            let networkUseCase = resolver.resolveUnwrapping(NetworkFetchUseCase.self, argument: defaultNetwork)
            return ItemViewModel(networkUseCase: networkUseCase)
        }
        
        container.register(ItemViewModel.self) { (resolver: Resolver, defaultNetwork: DefaultNetworkService) -> ItemViewModel<Vehicle> in
            let networkUseCase = resolver.resolveUnwrapping(NetworkFetchUseCase.self, argument: defaultNetwork)
            return ItemViewModel(networkUseCase: networkUseCase)
        }
        
        container.register(ItemViewModel.self) { (resolver: Resolver, defaultNetwork: DefaultNetworkService) -> ItemViewModel<Species> in
            let networkUseCase = resolver.resolveUnwrapping(NetworkFetchUseCase.self, argument: defaultNetwork)
            return ItemViewModel(networkUseCase: networkUseCase)
        }
    }
    
    private func registerItemsViewControllers(container: Container) {
        container.register(ItemViewController.self) { (resolver: Resolver, defaultNetwork: DefaultNetworkService) -> ItemViewController<ItemViewModel<Person>> in
            let viewModel = resolver.resolveUnwrapping(ItemViewModel<Person>.self, argument: defaultNetwork)
            return ItemViewController(viewModel: viewModel)
        }
        container.register(ItemViewController.self) { (resolver: Resolver, defaultNetwork: DefaultNetworkService) -> ItemViewController<ItemViewModel<Planet>> in
            let viewModel = resolver.resolveUnwrapping(ItemViewModel<Planet>.self, argument: defaultNetwork)
            return ItemViewController(viewModel: viewModel)
        }
        container.register(ItemViewController.self) { (resolver: Resolver, defaultNetwork: DefaultNetworkService) -> ItemViewController<ItemViewModel<Film>> in
            let viewModel = resolver.resolveUnwrapping(ItemViewModel<Film>.self, argument: defaultNetwork)
            return ItemViewController(viewModel: viewModel)
        }
        container.register(ItemViewController.self) { (resolver: Resolver, defaultNetwork: DefaultNetworkService) -> ItemViewController<ItemViewModel<Starship>> in
            let viewModel = resolver.resolveUnwrapping(ItemViewModel<Starship>.self, argument: defaultNetwork)
            return ItemViewController(viewModel: viewModel)
        }
        container.register(ItemViewController.self) { (resolver: Resolver, defaultNetwork: DefaultNetworkService) -> ItemViewController<ItemViewModel<Vehicle>> in
            let viewModel = resolver.resolveUnwrapping(ItemViewModel<Vehicle>.self, argument: defaultNetwork)
            return ItemViewController(viewModel: viewModel)
        }
        container.register(ItemViewController.self) { (resolver: Resolver, defaultNetwork: DefaultNetworkService) -> ItemViewController<ItemViewModel<Species>> in
            let viewModel = resolver.resolveUnwrapping(ItemViewModel<Species>.self, argument: defaultNetwork)
            return ItemViewController(viewModel: viewModel)
        }
    }
}
