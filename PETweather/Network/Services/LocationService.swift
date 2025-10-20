import CoreLocation
import Foundation

struct LocationCoordinates {
    let latitude: Double
    let longitude: Double
}

class LocationService: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationService()
    private var locationManager = CLLocationManager()
    private var onLocationResults:((Result<LocationCoordinates, Error>)->Void)?
    
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func getUserLocation(complition: @escaping ((Result<LocationCoordinates, Error>) -> Void)) {
        self.onLocationResults = complition
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }
        
        let coordinates = LocationCoordinates(
            latitude: location.coordinate.latitude, longitude: location.coordinate.longitude
        )
        onLocationResults?(.success(coordinates))
        onLocationResults = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        onLocationResults?(.failure(error))
        onLocationResults = nil
    }
}
