
import UIKit

class ForecastViewController: UIViewController {

    private var delegate: WeatherPresenter?
    
    var cityName = ""
    
    lazy var forecastView: ForecastTableView = {
        let view = ForecastTableView()
        view.delegate = self
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    override func viewDidLoad() {
        view.addSubview(forecastView)
        view.backgroundColor = .systemGray
        
        delegate = WeatherPresenter(view: self)
        delegate?.getWeatherByCity(city: cityName)
        
        NSLayoutConstraint.activate([
            forecastView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100),
            forecastView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            forecastView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            forecastView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
}

extension ForecastViewController: CustomTableViewDelegate {
    func didTapOnCell(at indexPath: IndexPath) {
        print ("\(indexPath)")
    }
}
extension ForecastViewController: WeatherProtocol {
    func getWeather(_ weather: WeatherModel) {
        forecastView.setData(weather)
        
    }
    func displayError(_ error: String) {
        print(error)
    }
}
