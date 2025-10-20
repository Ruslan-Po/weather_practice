
import UIKit

class MainViewController: UIViewController {
    
    private var delegate: WeatherPresenter?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        delegate = WeatherPresenter(view:self)
        delegate?.getWeatherByCity(city: "Moscow")
    }
}

extension MainViewController: WeatherProtocol{
    func displayWeather(_ weather: WeatherModel) {
        print ("\(weather.list[5].main)")
        print ("\(weather.city.name)")
    }
    
    func displayError(_ error: String) {
        print (error)
    }
    
}
