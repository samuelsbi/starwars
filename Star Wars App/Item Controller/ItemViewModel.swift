import UIKit
import RxSwift

protocol ItemViewModelProtocol {
    associatedtype Item
    
    var errorHandler: ErrorHandler? { get set }
    var reloadDataDelegate: ReloadDataDelegate? { get set }

    func getStatus() -> ActivityStatus
    func fillData(details: String)
    func getDescription(at index: Int) -> ItemDescription
    func getDescriptionsCount() -> Int
    func preConfigure(with url: String)
    func setURL(url: String)
}

class ItemViewModel<Item: Codable>: ItemViewModelProtocol {
    
    // MARK: - PROPERTIES
    private var status: ActivityStatus
    private var item: Item?
    private var itemDescriptions: [ItemDescription] = []
    private var networkUseCase: NetworkFetchUseCase
    private var url: String
    
    weak var errorHandler: ErrorHandler?
    weak var reloadDataDelegate: ReloadDataDelegate?

    // MARK: - INITIALIZERS
    
    init(networkUseCase: NetworkFetchUseCase, url: String) {
        self.networkUseCase = networkUseCase
        self.status = .idle
        self.url = url
    }
    
    // MARK: - PUBLIC METHODS
    
    func getStatus() -> ActivityStatus {
        return status
    }
    
    func getDescription(at index: Int) -> ItemDescription {
        return itemDescriptions[index]
    }
    
    func getDescriptionsCount() -> Int {
        return itemDescriptions.count
    }
    
    func preConfigure(with url: String) {
        status = .running
        reloadDataDelegate?.reloadData()
        networkUseCase.execute(from: url) { [weak self] (result: Result<Item,Error>) in
            self?.handleResult(result: result)
        }
    }
    
    func fillData(details: String = "") {
        self.item = nil
        status = .running
        reloadDataDelegate?.reloadData()
        networkUseCase.execute(from: self.url + details) { [weak self] (result: Result<Item,Error>) in
            self?.handleResult(result: result)
        }
    }
    
    func setURL(url: String) {
        self.url = url
    }
    
    private func reset() {
        item = nil
        itemDescriptions = []
        reloadDataDelegate?.reloadData()
    }
    
    // MARK: - PRIVATE METHODS
    
    private func handleResult(result: Result<Item,Error>) {
        switch result {
        case let .success(item):
            self.item = item
            setDescription()
            status = .success
        case let .failure(error):
            handleError(error: error)
            status = .idle
        }
        reloadDataDelegate?.reloadData()
    }
    private func handleError(error: Error) {
        reset()
        errorHandler?.handle(error: error)
    }
    
    private func setDescription() {
        guard let item = item else {
            return
        }
        let properties = Mirror(reflecting: item.self).children
        
        for p in properties {
            guard let label = p.label else { continue }
            if let value = p.value as? String {
                if value.range(of: "https://") != nil || value.range(of: "http://") != nil {
                    itemDescriptions.append(ItemDescription(label: label, value: .url(title: "Discover", link: value)))
                }
                else {
                    itemDescriptions.append(ItemDescription(label: label, value: .label(value)))
                }
            }
            
            else if let urls = p.value as? [String] {
                var index = 0
                for url in urls {
                    index += 1
                    itemDescriptions.append(ItemDescription(label: label, value: .url(title: "Discover \(index)", link: url)))
                }
            }
            
        }
        
    }
}

