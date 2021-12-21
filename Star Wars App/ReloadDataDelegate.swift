import UIKit

protocol ReloadDataDelegate: AnyObject {
    func reloadData()
}

extension ReloadDataDelegate where Self: UITableViewController {
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension ReloadDataDelegate where Self: UICollectionViewController {
    func reloadData() {
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}
