import UIKit

class ForecastTableView: UIView {
    
    private let cellIdentifier = "ForecastTableViewCell"
    private var forecastData: [Forecast] = []
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM"
        //formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
    
    lazy var forecastTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(WeatherTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        addSubview(forecastTableView)
        NSLayoutConstraint.activate([
            forecastTableView.topAnchor.constraint(equalTo: topAnchor),
            forecastTableView.bottomAnchor.constraint(equalTo: bottomAnchor),
            forecastTableView.leadingAnchor.constraint(equalTo: leadingAnchor),
            forecastTableView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    public func setData(_ newData: WeatherModel){
        var addedDays: Set<String> = []
        var filteredList: [Forecast] = []
        let calendar = Calendar.current

        let today = Date()
        let todayDay = calendar.component(.day, from: today)
        let todayMonth = calendar.component(.month, from: today)
        let todayIdentifier = "\(todayMonth)-\(todayDay)"
        
        for item in newData.list.dropFirst() {
            let date = Date(timeIntervalSince1970: TimeInterval(item.dt))
            let day = calendar.component(.day, from: date)
            let month = calendar.component(.month, from: date)
            let dayIdentifier = "\(month)-\(day)"
            
            if dayIdentifier != todayIdentifier && !addedDays.contains(dayIdentifier) {
                filteredList.append(item)
                addedDays.insert(dayIdentifier)
            }
        }
        self.forecastData = filteredList
        forecastTableView.reloadData()
    }
}

extension ForecastTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        forecastData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WeatherTableViewCell else {return UITableViewCell()}
        let item = forecastData[indexPath.row]
        
        cell.cellConfig(item: item , dateFormatter: dateFormatter)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Forecast"
    }
    
}
