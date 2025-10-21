import Foundation


class WeatherPresenter{
    
    private var longitude: Double?
    private var latitude: Double?
    
    weak var view: WeatherProtocol?
    private var weatherService = WeatherService()
    
    init(view:WeatherProtocol){
        self.view = view
    }
    
    func GetWeatherByLocation() {
        LocationService.shared.getUserLocation { [weak self] results in
            guard let self = self else {return}
            switch results {
            case .success(let location):
                self.latitude = location.latitude
                self.longitude = location.longitude
                self.fetchweather(lat: location.latitude, lon: location.longitude)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.view?.displayError("\(error)")
                }
            }
        }
    }
    
    func getWeatherByCity(city: String){
        LocationService.shared.getCoordinates(for: city) {[weak self] results in
            guard let self = self else {return}
            switch results {
            case .success(let coordinates):
                self.fetchweather(lat: coordinates.latitude, lon: coordinates.longitude)
            case .failure(let error):
                DispatchQueue.main.async {
                    self.view?.displayError("\(error)")
                }
            }
        }
    }
    
    func fetchweather(lat: Double, lon: Double){
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
