import UIKit
protocol WriteNameDelegate: AnyObject {
    func setText(_ text: String)
}
class WriteNameReusableView: UICollectionReusableView {
    
    // MARK: - PRIVATE PROPERTIES
    
    weak var delegate: WriteNameDelegate?
    
    // MARK: - UI
    
    private lazy var nameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Escreva o número do item que você quer saber mais"
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.delegate = self
        textField.keyboardType = .numberPad
        textField.textAlignment = .center
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 4.0
        textField.placeholder = "Digite um número"
        return textField
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Calcular", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(searchButtonAction), for: .touchUpInside)
        button.layer.backgroundColor = UIColor.systemOrange.cgColor
        button.layer.cornerRadius = 4.0
        button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        return button
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
    
    private func setupView() {
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func addSubviews() {
        self.addSubview(nameLabel)
        self.addSubview(textField)
        self.addSubview(searchButton)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            nameLabel.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 8),
            nameLabel.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -8),
            nameLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            textField.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            textField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            textField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 8),
            searchButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            searchButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            searchButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16)
        ])
    }

    // MARK: - ACTIONS
    
    @objc private func searchButtonAction(_ sender: UIButton) {
        
        if let text = textField.text {
            
            delegate?.setText(text)
        }
    }
}

extension WriteNameReusableView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let invalidCharacters = CharacterSet(charactersIn: "0123456789").inverted
        return string.rangeOfCharacter(from: invalidCharacters) == nil
    }
}
