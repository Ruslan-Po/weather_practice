import Foundation
import CoreLocation

protocol WeatherProtocol: AnyObject {
    func getWeather(_ weather: WeatherModel)
    func displayError(_ error: String)
    
}


protocol InputViewControllerDelegate: AnyObject {
    func didSelectCity(_ city: String)
    func didSelectCoordinate(_ coordinate: LocationCoordinates)
}

protocol Coordinator {
    func start()
}

protocol LocationStorageProtocol {
    func load() -> LastLocation?
    func save(_ location: LastLocation)
}

