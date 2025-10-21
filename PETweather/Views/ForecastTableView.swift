import UIKit

protocol CustomTableViewDelegate: AnyObject {
    func didTapOnCell(at indexPath: IndexPath)
}

class ForecastTableView: UIView {
    
    weak var delegate: CustomTableViewDelegate?
    
    private let cellIdentifier = "ForecastTableViewCell"
    private var forecastData: [Forecast] = []
    
    private let dateFormatter: DateFormatter = {
            let formatter = DateFormatter()
            formatter.dateFormat = "E, d MMM"
            formatter.locale = Locale(identifier: "ru_RU")
            return formatter
        }()
    
    lazy var forecastTableView: UITableView = {
        let tableView = UITableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellIdentifier)
        
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
        let calendar = Calendar.current
        self.forecastData = newData.list.filter { item in
            let date = Date(timeIntervalSince1970: TimeInterval(item.dt))
            let hour = calendar.component(.hour, from: date)
            return hour == 12
        }
        forecastTableView.reloadData()
    }
}

extension ForecastTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        forecastData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let item = forecastData[indexPath.row]
        
        let date = Date(timeIntervalSince1970: TimeInterval(item.dt))
        let dateString = dateFormatter.string(from: date)
        
        var config = cell.defaultContentConfiguration()
        config.text = "\(dateString) - \(item.main.feelsLike)  \(item.weather[0].description)"
        cell.contentConfiguration = config
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.didTapOnCell(at: indexPath)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        "Суканах"
    }
    
}
