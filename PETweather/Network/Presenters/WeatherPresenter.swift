import Foundation


class WeatherPresenter{
    
    private var longitude: Double?
    private var latitude: Double?
    
    weak var view: WeatherProtocol?
    private var weatherService = WeatherService()
    
    init(view: WeatherProtocol){
        self.view = view
    }
    
    func fetchWeatherByCity(city: String){
        LocationService.shared.getCoordinates(for: city) {[weak self] results in
            guard let self = self else {return}
            switch results {
            case .success(let coordinates):
                self.fetchWeatherByCoordinates(lat: coordinates.latitude, lon: coordinates.longitude)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.view?.displayError("\(error)")
                }
            }
        }
    }
    
    func fetchWeatherByCoordinates(lat: Double, lon: Double){
        weatherService.fetchWeatherData(longitude: lon, latitude: lat ) { [weak self] results in
            DispatchQueue.main.async {
                switch results {
                    case .success(let weatherModel):
                    self?.view?.getWeather(weatherModel)
                case .failure(let error):
                    self?.view?.displayError("\(error)")
                }
            }
        }
    }
}

