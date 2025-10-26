import Foundation


struct Greetings {
    
    var setGreetingByTime: String {
        let hour = Calendar.current.component(.hour, from: Date())
        
        switch hour {
        case 5..<12:
            return "Good Morning"
        case 12..<16:
            return "Good Afternoon"
        case 16..<20:
            return "Good Evening"
        default:
            return "Good Night"
        }
    }
}


struct DateTimeHelper {
     let hoursFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        return formatter
    }()
    
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d MMM"
        return formatter
    }()

    public func convertToHours(_ complition: DateFormatter,_ date: Int) -> String {
        let hours = Date(timeIntervalSince1970: TimeInterval(date))
        return complition.string(from: hours)
    }
    
    public func convertToDate (_ complition: DateFormatter,_ date: Int) -> String {
        let formatedDate = Date(timeIntervalSince1970: TimeInterval(date))
        return complition.string(from: formatedDate)
    }
}


struct ImagesByCodeHelper {
    func getImageNameByCode (code: Int) -> String {
        switch code {
        case 200...232:
           return "storm"
        case 300...531:
            return "rain"
        case 600...622:
            return "snow"
        case 701...781:
            return "fog"
        case 800:
            return "clearsky"
        case 801...804:
            return "cloud"
        default:
            return "uncknow"
        }
    }
}



