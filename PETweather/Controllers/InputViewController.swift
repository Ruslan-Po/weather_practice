import UIKit

class InputViewController: UIViewController{
    
    weak var delegate: InputViewControllerDelegate?
    
    var localCityName: String?
    
    private lazy var locationButton: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Использовать мою локацию", for: .normal)
            button.addTarget(self, action: #selector(didTapLocationButton), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
            return button
    }()
    
    private lazy var localTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Введите город"
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
        
        view.addSubview(locationButton)
        view.addSubview(localTextField)
        
        NSLayoutConstraint.activate([
            locationButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            locationButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            localTextField.topAnchor.constraint(equalTo: locationButton.bottomAnchor, constant: 10),
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
