import UIKit
import RxSwift
enum CollectionIndex: Int {
    case name
    case gender
}

//protocol ItemViewControllerProtocol: UICollectionViewController {
//    associatedtype ViewModel
//    var viewModel: ViewModel {get set}
//    var delegate: ItemViewControllerDelegate? { get set }
//}

class ItemViewController<ItemViewModel: ItemViewModelProtocol>: UICollectionViewController, ErrorHandler, ReloadDataDelegate {
    
    // MARK: - PRIVATE PROPERTIES
    
    internal var viewModel: ItemViewModel

    weak var delegate: ItemViewControllerDelegate?
    
    // MARK: - UI
    
    
    
    // MARK: - LIFE CYCLE
    
    init(viewModel: ItemViewModel) {
        self.viewModel = viewModel
        
        let flowLayout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: flowLayout)
        
        configureFlowLayout(flowLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        setupDelegates()
    }
    
    // MARK: - SETUP
    private func setupDelegates() {
        viewModel.errorHandler = self
        viewModel.reloadDataDelegate = self
    }
    
    private func setupView() {
        self.collectionView.backgroundColor = .systemBackground
        
        collectionView.register(WriteNameReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "WriteNameView")
        collectionView.register(ConclusionReusableView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "ConclusionView")
        collectionView.register(DescriptionCollectionViewCell.self, forCellWithReuseIdentifier: "DescriptionView")
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        
    }
    
    private func configureFlowLayout(_ flowLayout: UICollectionViewFlowLayout) {
        flowLayout.headerReferenceSize = CGSize(width: self.view.frame.width, height: 160)
        flowLayout.footerReferenceSize = CGSize(width: self.view.frame.width, height: 40)
        flowLayout.estimatedItemSize = CGSize(width: self.view.frame.width, height: 200)
        
    }
    
    // MARK: - PUBLIC METHODS
    
    public func preConfigureViewModel(with url: String) {
        self.viewModel.preConfigure(with: url)
    }

    // MARK: - Collection View
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getDescriptionsCount()
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        1
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DescriptionView", for: indexPath) as? DescriptionCollectionViewCell else {
            fatalError("Could not load DescriptionCollectionViewCell")
        }
        cell.delegate = self
        let description = viewModel.getDescription(at: indexPath.row)
        cell.fillData(itemDescription: description)
        return cell
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "WriteNameView", for: indexPath) as? WriteNameReusableView else {
                fatalError("Could not create Header")
            }
            header.delegate = self
            return header
            
        case UICollectionView.elementKindSectionFooter:
            guard let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "ConclusionView", for: indexPath) as? ConclusionReusableView else {
                fatalError("Could not create Footer")
            }
            footer.updateView(status: viewModel.getStatus())
            return footer
        default:
            return UICollectionReusableView()
        }
        
    }
}

extension ItemViewController: WriteNameDelegate {
    func setText(_ text: String) {
        self.viewModel.fillData(details: text)
        collectionView.collectionViewLayout.invalidateLayout()
        
    }
    
}

extension ItemViewController: LinkedDescriptionProtocol {
    func show(url: String) {
        delegate?.showPreLoadedItem(from: url)
    }
}
