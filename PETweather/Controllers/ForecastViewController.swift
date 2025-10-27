
import UIKit

class ForecastViewController: UIViewController {

    private var delegate: WeatherPresenter?
    
    var city: City?
    
    lazy var forecastTableView: ForecastTableView = {
        let view = ForecastTableView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        view.addSubview(forecastTableView)
        view.backgroundColor = .systemGray
        delegate = WeatherPresenter(view: self)
        
        if let city = self.city {
            delegate?.fetchWeatherByCoordinates(lat: city.coord.lat, lon: city.coord.lon)
            forecastTableView.tableTitle = city.name
        } else { print ("Didn't get city")}

        
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
