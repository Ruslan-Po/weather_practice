import CoreLocation
import Foundation

struct LocationCoordinates {
    let latitude: Double
    let longitude: Double
}

enum GeocodingError: Error {
    case cityNotFound
}

class LocationService: NSObject, CLLocationManagerDelegate {
    static let shared = LocationService()
    private var locationManager = CLLocationManager()
    private let geocoder = CLGeocoder()
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
            latitude: location.coordinate.latitude,
            longitude: location.coordinate.longitude
        )
        onLocationResults?(.success(coordinates))
        onLocationResults = nil
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: any Error) {
        onLocationResults?(.failure(error))
        onLocationResults = nil
    }
    
    func getCoordinates(for cityName: String, complition: @escaping ((Result<LocationCoordinates, Error>) -> Void)){
        geocoder.geocodeAddressString(cityName){ placemark, error  in
            
            if let error = error {
                DispatchQueue.main.async {
                    complition(.failure(error))
                    return
                }
            }
            
            guard let placemark = placemark?.first,let location = placemark.location else {
                DispatchQueue.main.async {
                    complition(.failure(GeocodingError.cityNotFound))
                }
                return
            }
            let coordinates = LocationCoordinates(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude)
            
            DispatchQueue.main.async {
                complition(.success(coordinates))
            }
        }
    }
}
