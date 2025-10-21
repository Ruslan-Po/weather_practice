
import UIKit

class MainViewController: UIViewController {
    
    private var delegate: WeatherPresenter?
    var cityName: String = "Paris"
    
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
        vc.cityName = self.cityName
        vc.navigationController?.pushViewController(vc, animated: true)
        present(vc, animated: true)
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
        delegate?.getWeatherByCity(city: cityName)
    }
}

extension MainViewController: WeatherProtocol{
    func getWeather(_ weather: WeatherModel) {
        print ("\(weather.list[0].main)")
        print ("\(weather.city.name)")
    }
    
    func displayError(_ error: String) {
        print (error)
    }
    
}
