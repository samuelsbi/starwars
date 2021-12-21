import Swinject
protocol ItemFactoryProtocol {
    func makeItemViewController<Item: Codable>(ItemType: Item.Type, url: String, network: DefaultNetworkService) -> ItemViewController<ItemViewModel<Item>>
}
class ItemFactory: ItemFactoryProtocol {
    
    // MARK: - PRIVATE PROPERTIES
    
    private let resolver: Resolver
    
    // MARK: - INITIALIZER
    
    public init(resolver: Resolver) {
        self.resolver = resolver
    }
    
    // MARK: - FACTORY
    
    public func makeItemViewController<Item: Codable>(ItemType: Item.Type, url: String, network: DefaultNetworkService) -> ItemViewController<ItemViewModel<Item>> {
        return resolver.resolveUnwrapping(ItemViewController.self, arguments: url, network)
        
    }
    
}
