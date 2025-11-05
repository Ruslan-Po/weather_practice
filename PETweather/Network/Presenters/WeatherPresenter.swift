import Foundation


class WeatherPresenter{
    
    private var longitude: Double?
    private var latitude: Double?
    
    weak var view: WeatherProtocol?
    private var weatherService = WeatherService()
    
    var inicialCityName: String?
    var inicialCoordinates: LocationCoordinates?
    
    let greetings: Greetings
    let localDatetimeHelper: DateTimeHelper
    let imagesByCode: ImagesByCodeHelper
    
    init(view: WeatherProtocol,
         greetings: Greetings,
         localDatetimeHelper: DateTimeHelper,
         imagesByCode: ImagesByCodeHelper){
        self.view = view
        self.greetings = greetings
        self.localDatetimeHelper = localDatetimeHelper
        self.imagesByCode = imagesByCode
    }
    
    func getWeatherByInputResponse() {
        if let cityName = self.inicialCityName {
            self.fetchWeatherByCity(city: cityName)
        } else if let coord = self.inicialCoordinates {
            self.fetchWeatherByCoordinates(lat: coord.latitude, lon: coord.longitude)
        }
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
    
    func filter(weatherModel: WeatherModel) -> [Forecast] {
       var addedDays: Set<Date> = []
       var filteredList: [Forecast] = []
       let calendar = Calendar.current
       let todayStart = calendar.startOfDay(for: Date())
       
       for item in weatherModel.list.dropFirst() {
           let date = Date(timeIntervalSince1970: TimeInterval(item.dt))
           let dayStart = calendar.startOfDay(for: date)
           
           if dayStart != todayStart && !addedDays.contains(dayStart) {
               filteredList.append(item)
               addedDays.insert(dayStart)
           }
       }
       return filteredList
   }
    
    func greetingUppercased(for date: Date) -> String {
        greetings.setGreetingByTime.uppercased()
    }

    func formattedTime(_ date: Date) -> String {
        localDatetimeHelper.hoursFormatter.string(from: date)
    }

    func formattedDate(_ date: Date) -> String {
        localDatetimeHelper.dateFormatter.string(from: date).capitalized
    }

    func formattedHours(from unix: TimeInterval) -> String {
        localDatetimeHelper.convertToHours(localDatetimeHelper.hoursFormatter, Int(unix))
    }

    func imageName(forCode code: Int) -> String {
        imagesByCode.getImageNameByCode(code: code)
    }
}

