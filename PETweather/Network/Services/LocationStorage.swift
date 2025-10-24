import UIKit

struct LastLocation: Codable {
    let city: String?
    let coordinates: LocationCoordinates?
    
    init(city: String){
        self.city = city
        self.coordinates = nil
    }
    
    init(coordinates: LocationCoordinates){
        self.city = nil
        self.coordinates = coordinates
    }
}

class LocationStorageManager {
    private static let key = "lastKnownLocation"
    static func save (_ location: LastLocation ) {
        do{
            let data = try JSONEncoder().encode(location)
            UserDefaults.standard.set(data, forKey: key)
        }catch {
            print ("Encode location error")
        }
    }
    
    static func load () -> LastLocation? {
        guard let data = UserDefaults.standard.data(forKey: key) else {
            return nil
        }
        do {
            let location = try JSONDecoder().decode(LastLocation.self, from: data)
            return location
        } catch {
            print ("Decode location error")
            return nil
        }
    }
}
