import Foundation


struct Greetings {
    enum greetings{
        case goodMorning
        case goodAfternoon
        case goodEvening
        case goodNight
    }
    
    private func getGreetings(greetings: greetings) -> String {
        switch greetings {
        case .goodMorning:
            return "Good Morning"
        case .goodAfternoon:
            return "Good Afternoon"
        case .goodEvening:
            return "Good Evening"
        case .goodNight:
            return "Good Night"
        }
    }
    
    var setGreetingByTime: String {
        let hour = Calendar.current.component(.hour, from: Date())
        var currentGreetings: greetings
        
        switch hour {
        case 5..<12:
            currentGreetings = .goodMorning
        case 12..<16:
            currentGreetings = .goodAfternoon
        case 16..<20:
            currentGreetings = .goodEvening
        default:
            currentGreetings = .goodNight
        }
        return getGreetings(greetings: currentGreetings)
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



