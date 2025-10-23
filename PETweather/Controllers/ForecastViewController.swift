
import UIKit

class ForecastViewController: UIViewController {

    private var delegate: WeatherPresenter?
    
    var cityName = ""
    
    lazy var forecastTableView: ForecastTableView = {
        let view = ForecastTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        view.addSubview(forecastTableView)
        view.backgroundColor = .systemGray
        delegate = WeatherPresenter(view: self)
        delegate?.fetchWeatherByCity(city: cityName)
        
        NSLayoutConstraint.activate([
            forecastTableView.topAnchor.constraint(equalTo: view.topAnchor),
            forecastTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            forecastTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            forecastTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}

extension ForecastViewController: WeatherProtocol {
    func getWeather(_ weather: WeatherModel) {
        forecastTableView.setData(weather)
    }
    
    func displayError(_ error: String) {
        print(error)
    }
}
