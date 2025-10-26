import UIKit

class InputViewController: UIViewController{
    
    weak var delegate: InputViewControllerDelegate?
    
    var localCityName: String?
    
    private lazy var locationButton: UIButton = {
        let button = UIButton()
        button.setTitle("Use my Location", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.white.cgColor
        button.addTarget(self, action: #selector(didTapLocationButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var OrlabelView: UILabel = {
       let label = UILabel()
        label.text  = "OR"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var localTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Enter city"
        field.textAlignment = .center
        field.layer.cornerRadius = 8
        field.backgroundColor = .white
        field.delegate = self
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    
    @objc private func didTapLocationButton() {
        LocationService.shared.getUserLocation { [weak self] results in
            guard let self = self else {return}
            switch results {
            case .success(let coords ):
                self.delegate?.didSelectCoordinate(coords)
            case .failure(let error):
               print("\(error)")
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray3
        view.addSubview(locationButton)
        view.addSubview(localTextField)
        view.addSubview(OrlabelView)
        
        NSLayoutConstraint.activate([
            locationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            locationButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            locationButton.heightAnchor.constraint(equalToConstant: 40),
            locationButton.widthAnchor.constraint(equalToConstant: 150),
            
            OrlabelView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            OrlabelView.topAnchor.constraint(equalTo: locationButton.bottomAnchor, constant: 15),

            
            localTextField.topAnchor.constraint(equalTo: OrlabelView.bottomAnchor, constant: 10),
            localTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            localTextField.heightAnchor.constraint(equalToConstant: 30),
            localTextField.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
}

extension InputViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        delegate?.didSelectCity(textField.text ?? "")
        return true
    }
}
