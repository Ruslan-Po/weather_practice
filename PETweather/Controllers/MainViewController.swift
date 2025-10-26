
import UIKit

class MainViewController: UIViewController {
    
    //MARK: - Variables
    private var delegate: WeatherPresenter?
    var inicialCityName: String?
    var inicialCoordinates: LocationCoordinates?
    var currentTime = Date()
    let greetings = Greetings()
    let localDatetimeHelper = DateTimeHelper()
    let imagesByCode = ImagesByCodeHelper()
    
    
    
    //MARK: - UI_Elements
    
    
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.text = inicialCityName
        label.textColor = .systemGray
        label.font = UIFont.systemFont(ofSize: 25, weight: .thin)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var weatherImage: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .red
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.text = "-- °C"
        label.font = UIFont.systemFont(ofSize: 70, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var greetingsLabel: UILabel = {
        let label = UILabel()
        label.text = greetings.setGreetingByTime.uppercased()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    lazy var timeLabel: UILabel = {
        let label = UILabel()
        //label.text = "--:--"
        label.text = localDatetimeHelper.hoursFormatter.string(from: currentTime)
        label.font = UIFont.systemFont(ofSize: 30, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.text = localDatetimeHelper.dateFormatter.string(from: currentTime).capitalized
        label.font = UIFont.systemFont(ofSize: 20, weight: .light)
        label.translatesAutoresizingMaskIntoConstraints=false
        return label
    }()
    
    lazy var dateTimeStackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [greetingsLabel,timeLabel, dateLabel])
        stack.distribution = .fillEqually
        stack.axis = .vertical
        stack.spacing = 8
        stack.alignment = .center
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    lazy var forecastButton: UIButton = {
        let button = UIButton(type: .system)
        button.layer.cornerRadius = 8
        button.backgroundColor = .systemGray2
        button.setTitle("Forecast".uppercased(), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(showForecast), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var sunsetStackView: SunTimeView = {
        let stackView = SunTimeView(imageName: "sunset")
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var sunriseStackView: SunTimeView = {
        let stackView = SunTimeView(imageName: "sunrise")
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var sunStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [sunriseStackView, sunsetStackView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var locationButton: UIButton = {
        let button = UIButton(type: .system)
        let pointSize: CGFloat = 25.0
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: pointSize)
        let buttonImage = UIImage(systemName: "location.app.fill",withConfiguration: symbolConfig)
        button.tintColor = .gray

        button.setImage(buttonImage, for: .normal)
        button.addTarget(self, action: #selector(getUserLocation), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var textField: UITextField = {
        let field = UITextField()
        field.placeholder = "City name"
        field.delegate = self
        field.borderStyle = .roundedRect
        field.translatesAutoresizingMaskIntoConstraints = false
        return field
    }()
    
    //MARK: - Functions
    @objc func showForecast(){
        let vc = ForecastViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.cityName = self.inicialCityName ?? " "
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func getUserLocation(){
        
        LocationService.shared.getUserLocation { [weak self] results in
            guard let self = self else {return}
            switch results {
            case .success(let coords ):
                self.delegate?.fetchWeatherByCoordinates(lat: coords.latitude, lon: coords.longitude)
                let locationToSave = LastLocation(coordinates: coords)
                LocationStorageManager.save(locationToSave)
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    private func getWeatherByInputResponse(){
        if let cityName = self.inicialCityName{
            delegate?.fetchWeatherByCity(city: cityName)
        } else if let coord = self.inicialCoordinates {
            delegate?.fetchWeatherByCoordinates(lat: coord.latitude, lon: coord.longitude)
        }
    }
    
    func setupUI(){
        view.addSubview(forecastButton)
        
        view.addSubview(weatherImage)
        view.addSubview(temperatureLabel)
        
        view.addSubview(dateTimeStackView)
        view.addSubview(sunStackView)
        
        view.addSubview(textField)
        view.addSubview(locationButton)
        
        view.addSubview(cityLabel)
        
        NSLayoutConstraint.activate([
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            textField.trailingAnchor.constraint(equalTo: locationButton.leadingAnchor, constant: -10),
            
            locationButton.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 10),
            locationButton.centerYAnchor.constraint(equalTo: textField.centerYAnchor),
            locationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
            
            cityLabel.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            cityLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            weatherImage.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 10),
            weatherImage.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            weatherImage.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            temperatureLabel.topAnchor.constraint(equalTo: weatherImage.bottomAnchor, constant: 10),
            
            dateTimeStackView.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 15),
            dateTimeStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30),
            dateTimeStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30),
    
            
            sunStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            sunStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            sunStackView.topAnchor.constraint(equalTo: dateTimeStackView.bottomAnchor, constant: 10),
            
            forecastButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
            forecastButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            forecastButton.heightAnchor.constraint(equalToConstant: 40),
            forecastButton.widthAnchor.constraint(equalToConstant: 150)
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        delegate = WeatherPresenter(view:self)
        getWeatherByInputResponse()
        setupUI()
    }
}

//MARK: - Extensions

extension MainViewController: WeatherProtocol{
    func getWeather(_ weather: WeatherModel) {
        
        DispatchQueue.main.async {[weak self] in
            guard let self = self else { return }
            let temp = weather.list[0].main.temp
            self.temperatureLabel.text = "\(String(format: "%.1f", temp)) °C"
            
            self.sunsetStackView.timeLabel.text =
            localDatetimeHelper.convertToHours(localDatetimeHelper.hoursFormatter, weather.city.sunset)
            self.sunriseStackView.timeLabel.text =
            localDatetimeHelper.convertToHours(localDatetimeHelper.hoursFormatter, weather.city.sunrise)
            
            cityLabel.text = weather.city.name
            self.inicialCityName = weather.city.name
            
            weatherImage.image = UIImage(named: imagesByCode.getImageNameByCode(code: weather.list[0].weather[0].id))
//print("\(weather.list[0].weather[0].id)")
        }
    }
    
    func displayError(_ error: String) {
        print (error)
    }
}


extension MainViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print ("respond work")
        if let newCityName = textField.text {
            delegate?.fetchWeatherByCity(city: newCityName)
            let locationToSave = LastLocation(city: newCityName)
            LocationStorageManager.save(locationToSave)
            inicialCityName = newCityName
        }
        textField.text = ""
        textField.resignFirstResponder()
        return true
    }
}
