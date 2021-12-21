import UIKit
import RxSwift

protocol ItemViewModelProtocol {
    associatedtype Item
    
    var statusObserver: BehaviorSubject<ActivityStatus> {get}
    var errorObserver: PublishSubject<Error> {get}
    
    func getStatus() -> ActivityStatus
    func fillData(details: String)
    func getDescription(at index: Int) -> ItemDescription
    func getDescriptionsCount() -> Int
    func preConfigure(with url: String)
}

class ItemViewModel<Item: Codable & Searchable>: ItemViewModelProtocol {
    
    // MARK: - PROPERTIES
    private var item: Item?
    private var networkUseCase: NetworkFetchUseCase
    private var itemDescriptions: [ItemDescription] = []
    
    var statusObserver = BehaviorSubject<ActivityStatus>(value: .idle)
    var errorObserver = PublishSubject<Error>()
    // MARK: - INITIALIZERS
    
    init(networkUseCase: NetworkFetchUseCase) {
        self.networkUseCase = networkUseCase
        self.statusObserver.onNext(.idle)
    }
    
    // MARK: - PUBLIC METHODS
    
    func getStatus() -> ActivityStatus {
        do {
            let status = try statusObserver.value()
            print(status)
            return status
        } catch {
            fatalError(error.localizedDescription)
        }
    }
    
    func getDescription(at index: Int) -> ItemDescription {
        return itemDescriptions[index]
    }
    
    func getDescriptionsCount() -> Int {
        return itemDescriptions.count
    }
    
    func preConfigure(with url: String) {
        statusObserver.onNext(.running)
        networkUseCase.execute(from: url) { [weak self] (result: Result<Item,Error>) in
            self?.handleResult(result: result)
        }
    }
    
    func fillData(details: String = "") {
        self.item = nil
        statusObserver.onNext(.running)
        //reloadDataDelegate?.reloadData()
        networkUseCase.execute(from: Item.url() + details) { [weak self] (result: Result<Item,Error>) in
            self?.handleResult(result: result)
        }
    }
    
    private func reset() {
        item = nil
        statusObserver.onNext(.idle)
    }
    
    // MARK: - PRIVATE METHODS
    
    private func handleResult(result: Result<Item,Error>) {
        switch result {
        case let .success(item):
            self.item = item
            setDescription()
            statusObserver.onNext(.success)
        case let .failure(error):
            handleError(error: error)
        }
    }
    private func handleError(error: Error) {
        reset()
        errorObserver.onNext(error)
    }
    
    private func setDescription() {
        guard let item = item else {
            return
        }
        let descriptions = mirrorAttributes(from: item)
        itemDescriptions = descriptions
    }
    
    private func mirrorAttributes(from object: Any) -> [ItemDescription] {
        var descriptions: [ItemDescription] = []
        let properties = Mirror(reflecting: object.self).children
        for p in properties {
            guard let label = p.label else { continue }
            if let value = p.value as? String {
                if value.range(of: "https://") != nil || value.range(of: "http://") != nil {
                    descriptions.append(ItemDescription(label: label, value: .url(title: "Discover", link: value)))
                }
                else {
                    descriptions.append(ItemDescription(label: label, value: .label(value)))
                }
            }
            
            else if let urls = p.value as? [String] {
                var index = 0
                for url in urls {
                    index += 1
                    descriptions.append(ItemDescription(label: label, value: .url(title: "Discover \(index)", link: url)))
                }
            }
        }
        return descriptions
    }
}

