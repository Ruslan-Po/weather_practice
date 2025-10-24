
import UIKit

class MainViewController: UIViewController {

    //MARK: - Variables
    private var delegate: WeatherPresenter?
    var inicialCityName: String?
    var inicialCoordinates: LocationCoordinates?
    var currentTime = Date()
    var greetings = Greetings()
    let localDatetimeHelper = DateTimeHelper()

    
    
    //MARK: - UI_Elements
    lazy var temperatureLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "-- °C"
        label.font = UIFont.systemFont(ofSize: 70, weight: .bold)
        return label
    }()
    
    lazy var greetingsLabel: UILabel = {
        let label = UILabel()
        label.text = greetings.setGreetingByTime.uppercased()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    lazy var forecastButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forecast", for: .normal)
        button.addTarget(self, action: #selector(showForecast), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    lazy var sunsetStackView: SunTimeView = {
        let stackView = SunTimeView(imageName: "sunset")
        stackView.backgroundColor = .systemGray
        stackView.layer.cornerRadius = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var sunriseStackView: SunTimeView = {
        let stackView = SunTimeView(imageName: "sunrise")
        stackView.backgroundColor = .systemGray
        stackView.layer.cornerRadius = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    lazy var sunStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [sunsetStackView, sunriseStackView])
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    //MARK: - Functions
    @objc func showForecast(){
        let vc = ForecastViewController()
        vc.modalPresentationStyle = .fullScreen
        vc.cityName = self.inicialCityName ?? " " 
        self.navigationController?.pushViewController(vc, animated: true)
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
        view.addSubview(greetingsLabel)
        view.addSubview(temperatureLabel)
        view.addSubview(sunStackView)
        
        NSLayoutConstraint.activate([
            temperatureLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            temperatureLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            greetingsLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            greetingsLabel.topAnchor.constraint(equalTo: temperatureLabel.bottomAnchor, constant: 20),
            
            forecastButton.topAnchor.constraint(equalTo: greetingsLabel.bottomAnchor, constant: 20),
            forecastButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            sunStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            sunStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            sunStackView.topAnchor.constraint(equalTo: forecastButton.bottomAnchor, constant: 10)
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
        }

    }
    
    func displayError(_ error: String) {
        print (error)
    }
}


