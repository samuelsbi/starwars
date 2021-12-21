import UIKit

class ConclusionReusableView: UICollectionReusableView {
    
    // MARK: - UI
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Só encontramos esses dados sobre esse item!"
        label.numberOfLines = 0
        label.textColor = label.textColor.withAlphaComponent(0.8)
        label.font = label.font.withSize(10)
        return label
    }()
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        indicator.hidesWhenStopped = true
        indicator.stopAnimating()
        return indicator
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
        
        updateView(status: .idle)
    }
    
    private func addSubviews() {
        self.addSubview(label)
        self.addSubview(indicator)
    }
    
    private func setConstraints() {
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 8),
            label.topAnchor.constraint(equalTo: topAnchor, constant: 8),
            label.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8),
            label.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8),
            indicator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0),
            indicator.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            indicator.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0),
            indicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0)
        ])
    }
    
    func updateView(status: ActivityStatus) {
        switch status {
        case .idle:
            label.isHidden = true
            indicator.stopAnimating()
        case .running:
            label.isHidden = true
            indicator.startAnimating()
        case .success:
            label.isHidden = false
            indicator.stopAnimating()
        }
    }
}
