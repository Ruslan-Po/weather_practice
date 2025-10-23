import Foundation
import CoreLocation

protocol WeatherProtocol: AnyObject {
    func getWeather(_ weather: WeatherModel)
    func displayError(_ error: String)
}


