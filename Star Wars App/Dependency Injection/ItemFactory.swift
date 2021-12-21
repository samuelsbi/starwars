import Swinject
protocol ItemFactoryProtocol {
    func makeItemViewController<Item: Codable & Searchable>(ItemType: Item.Type, network: DefaultNetworkService) -> ItemViewController<ItemViewModel<Item>>
}
class ItemFactory: ItemFactoryProtocol {
    
    // MARK: - PRIVATE PROPERTIES
    
    private let resolver: Resolver
    
    // MARK: - INITIALIZER
    
    public init(resolver: Resolver) {
        self.resolver = resolver
    }
    
    // MARK: - FACTORY
    
    public func makeItemViewController<Item: Codable & Searchable>(ItemType: Item.Type, network: DefaultNetworkService) -> ItemViewController<ItemViewModel<Item>> {
        return resolver.resolveUnwrapping(ItemViewController.self, argument: network)
        
    }
    
}
