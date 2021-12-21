import UIKit

class DashboardViewController: UIViewController {

    // MARK: - PRIVATE PROPERTIES
    
    // MARK: - PUBLIC PROPERTIES
    
    weak var delegate: DashboardViewControllerDelegate?
    
    // MARK: - UI
    
    private lazy var urlSessionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("URL Session", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.addTarget(self, action: #selector(urlSessionButtonAction), for: .touchUpInside)
        return button
    }()
    
    private lazy var alamofireButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Alamofire", for: .normal)
        button.setTitleColor(.link, for: .normal)
        button.addTarget(self, action: #selector(alamofireButtonAction), for: .touchUpInside)
        return button
    }()
    
    // MARK: - LIFE CYCLE
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        addSubviews()
        setupConstraints()
    }
    
    // MARK: - SETUP
    
    func setupView() {
        navigationItem.title = "Dashboard"
        view.backgroundColor = .systemBackground
    }
    
    func addSubviews() {
        view.addSubview(urlSessionButton)
        view.addSubview(alamofireButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            urlSessionButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            urlSessionButton.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -40),
            alamofireButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            alamofireButton.topAnchor.constraint(equalTo: urlSessionButton.bottomAnchor, constant: 80)
        ])
    }
    
    @objc private func urlSessionButtonAction(_ sender: UIButton) {
        delegate?.showPersonURLSession()
    }
    
    @objc private func alamofireButtonAction(_ sender: UIButton) {
        delegate?.showPersonAlamofire()
    }

}
