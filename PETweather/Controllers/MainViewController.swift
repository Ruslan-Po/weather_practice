
import UIKit

class MainViewController: UIViewController {

    private var delegate: WeatherPresenter?
    var inicialCityName: String?
    var inicialCoordinates: LocationCoordinates?

    lazy var forecastButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Forecast", for: .normal)
        button.addTarget(self, action: #selector(showForecast), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(forecastButton)
        view.backgroundColor = .white
        
        NSLayoutConstraint.activate([
            forecastButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            forecastButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        delegate = WeatherPresenter(view:self)
        getWeatherByInputResponse()
        //delegate?.getWeatherByCity(city: inicialCityName ?? "")
    }
}

extension MainViewController: WeatherProtocol{
    func getWeather(_ weather: WeatherModel) {
        print ("\(weather.list[0].main)")
        print ("\(weather.city.name)")
        inicialCityName = weather.city.name
    }
    
    func displayError(_ error: String) {
        print (error)
    }
}

