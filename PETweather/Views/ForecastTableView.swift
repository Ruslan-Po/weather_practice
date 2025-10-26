import UIKit

class ForecastTableView: UIView {
    
    private let cellIdentifier = "ForecastTableViewCell"
    private var forecastData: [Forecast] = []
    var tableTitle: String? = nil
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "E, d MMM"
        return formatter
    }()
    
    lazy var forecastTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 120
        tableView.register(ForecastTableViewCell.self, forCellReuseIdentifier: cellIdentifier)
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
        var addedDays: Set<Date> = []
        var filteredList: [Forecast] = []
        let calendar = Calendar.current
        
        let todayStart = calendar.startOfDay(for: Date())
        
        for item in newData.list.dropFirst() {
                let date = Date(timeIntervalSince1970: TimeInterval(item.dt))
                let dayStart = calendar.startOfDay(for: date)
                
                if dayStart != todayStart && !addedDays.contains(dayStart) {
                    filteredList.append(item)
                    addedDays.insert(dayStart)
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? ForecastTableViewCell else {return UITableViewCell()}
        let item = forecastData[indexPath.row]
        cell.cellConfig(item: item , dateFormatter: dateFormatter)
        return cell
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = tableTitle
        
        return title
    }
    
    
}
