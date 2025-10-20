import Foundation
import CoreLocation

protocol WeatherProtocol: AnyObject {
    func displayWeather(_ weather: WeatherModel)
    func displayError(_ error: String)
}

