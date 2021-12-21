import UIKit

protocol LinkedDescriptionProtocol: AnyObject {
    func show(url: String)
}

class DescriptionCollectionViewCell: UICollectionViewCell {
    
    // MARK: - PRIVATE PROPERTIES
    private var itemDescription: ItemDescription?
    weak var delegate: LinkedDescriptionProtocol?

    // MARK: - UI
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "description"
        label.textAlignment = .left
        label.numberOfLines = 1
        return label
    }()
    
    private lazy var valueLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "value"
        label.numberOfLines = 3
        label.font = .boldSystemFont(ofSize: 18)
        return label
    }()
    
    // MARK: - LIFE CYCLE
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupView()
        addSubviews()
        setConstraints()
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - SETUP
    
    func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = UIColor.systemGray5.withAlphaComponent(0.8)
        layer.cornerRadius = 10
    }
    
    private func addSubviews() {
        self.addSubview(descriptionLabel)
        self.addSubview(valueLabel)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            
            descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            descriptionLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -10),
            descriptionLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            valueLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 8),
            valueLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -16),
            valueLabel.leadingAnchor.constraint(equalTo: descriptionLabel.leadingAnchor, constant: 8),
            valueLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - METHODS
    
    func fillData(itemDescription: ItemDescription) {
        self.itemDescription = itemDescription
        
        if case .url(_,_) = itemDescription.value {
            configureLabelAsButton()
        }
        else {
            valueLabel.textColor = descriptionLabel.textColor
        }
        descriptionLabel.text = itemDescription.label + ":"
        switch itemDescription.value {
        case let .label(value):
            valueLabel.text = value
        case let .url(title: title, link: _):
            valueLabel.text = title
        }
    }

    private func configureLabelAsButton(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(pressButtonAction))
        valueLabel.isUserInteractionEnabled = true
        valueLabel.addGestureRecognizer(tap)
        valueLabel.textColor = .systemOrange
    }
    
    // MARK: - ACTIONS
    @objc private func pressButtonAction(_ sender: Any) {
        if case let(.url(_, link)) = itemDescription?.value {
            delegate?.show(url: link)
        }
    }
}

