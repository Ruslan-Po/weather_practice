import Foundation

enum WeatherErrors: Error {
    case invalidURL
    case URLconstructionFailed
    case noData
    case decodingFailed
}

class WeatherService {
    let apiKey = "7cdd70a88a12f2058c790ed2952ac54a"
    
    func createWeatherURL(lon: Double, lat: Double, key: String) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.openweathermap.org"
        components.path = "/data/2.5/forecast"
        
        components.queryItems = [
            URLQueryItem (name: "lat",value: String(lat)),
            URLQueryItem (name: "lon",value: String(lon)),
            URLQueryItem (name: "appid",value: key),
            URLQueryItem(name: "units", value: "metric")
        ]
        return components.url
    }
    
    func fetchWeatherData(longitude: Double,latitude: Double, completion: @escaping (Result<WeatherModel, Error>) -> Void) {
        
        guard let urlString = createWeatherURL(lon:longitude, lat: latitude, key: apiKey) else {
            completion(.failure(WeatherErrors.URLconstructionFailed))
            return
        }
        
        URLSession.shared.dataTask(with: urlString) { (data, _ , error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(WeatherErrors.noData))
                return
            }
            do {
                let weather = try JSONDecoder().decode(WeatherModel.self, from: data)
                    completion (.success(weather))
            } catch {
                completion (.failure(WeatherErrors.decodingFailed))
                return
            }
        }.resume()
    }
    

}
