import UIKit
import SnapKit
import CoreLocation

class ViewController: UIViewController {
//    let mapButton = UIButton(type: .system)
//    let searchButton = UIButton(type: .system)
    
    let cityLabel = UILabel()
    let temperLabel = UILabel()
    let descriptionLabel = UILabel()
    
    let weatherImageView = UIImageView()
    
    let tableView = UITableView()
    
    var myLocation: CLLocation? {
        didSet {
            locationDidFind(myLocation ?? CLLocation())
        }
    }
    var currentWeather: WeatherResponse?
    var currentCityName: String?
    
    let locationManager = CLLocationManager()
    let networkManager = Network()

    // MARK: -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = ""
        
        setupLayout()
        prepareViews()
        createLocationManager()
    }
    
    // MARK: -
    
    func setupLayout() {
        view.addSubview(weatherImageView)
        view.addSubview(tableView)
        
        view.addSubview(cityLabel)
        view.addSubview(temperLabel)
        view.addSubview(descriptionLabel)
        
//        weatherImageView.addSubview(cityLabel)
//        weatherImageView.addSubview(temperLabel)
//        weatherImageView.addSubview(descriptionLabel)
//        weatherImageView.addSubview(mapButton)
//        weatherImageView.addSubview(searchButton)
        
        weatherImageView.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.top.equalTo(temperLabel.snp.bottom)
            make.leading.equalTo(view.snp.leading).offset(10)
            make.trailing.equalTo(view.snp.trailing).offset(-10)
        }
        
        
        
//        mapButton.snp.makeConstraints { make in
//            make.height.equalTo(30)
//            make.width.equalTo(30)
//            make.top.equalTo(weatherImageView.snp.top).offset(5)
//            make.trailing.equalTo(searchButton.snp.leading).offset(-10)
//        }
        
//        searchButton.snp.makeConstraints { make in
//            make.height.equalTo(30)
//            make.width.equalTo(30)
//            make.top.equalTo(weatherImageView.snp.top).offset(5)
//            make.trailing.equalTo(weatherImageView.snp.trailing).offset(-7)
//        }
        
        cityLabel.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.width.equalTo(300)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(view.snp.top).offset(70)
        }
        
        temperLabel.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.width.equalTo(100)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(cityLabel.snp.bottom).offset(10)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.height.equalTo(60)
            make.width.equalTo(300)
            make.centerX.equalTo(view.snp.centerX)
            make.top.equalTo(weatherImageView.snp.bottom).offset(10)
//            make.bottom.equalTo(weatherImageView.snp.bottom).offset(-50)
        }
        
        tableView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(50)
            make.leading.equalTo(view.snp.leading).offset(15)
            make.trailing.equalTo(view.snp.trailing).offset(-15)
            make.bottom.equalTo(view.snp.bottom).offset(-20)
        }
    }
    func prepareViews() {
        view.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(NameTableCell.self, forCellReuseIdentifier: NameTableCell.cellName)
        
        weatherImageView.isUserInteractionEnabled = true
        weatherImageView.contentMode = .scaleAspectFill
        
        cityLabel.textColor = .black
        cityLabel.font = UIFont.systemFont(ofSize: 35)
        cityLabel.textAlignment = .center
        
        temperLabel.textColor = .black
        temperLabel.font = UIFont.systemFont(ofSize: 35)
        temperLabel.textAlignment = .center
        
        descriptionLabel.textColor = .black
        descriptionLabel.font = UIFont.systemFont(ofSize: 25)
        descriptionLabel.textAlignment = .center
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(
                image: UIImage(systemName: "magnifyingglass"),
                style: .done,
                target: self,
                action: #selector(searchButtonPress)
            ),
            UIBarButtonItem(
                image: UIImage(systemName: "map"),
                style: .done,
                target: self,
                action: #selector(mapButtonPress)
            )
        ]
    }
    
    // MARK: -
    
    func updateUI() {
        if let w = currentWeather {
            temperLabel.text = String(format: "%.1f", w.currentConditions.temp)
            descriptionLabel.text = w.currentConditions.conditions
//            updateWeatherImage(condition: w.currentConditions.icon)
        }
        
        tableView.reloadData()
    }
    
    func updateWeatherImage(condition: String) {
        var image: UIImage = UIImage(named: "sun")!
        if condition == "rain" {
            image = UIImage(named: "rain")!
        } else if condition == "snow" {
            image = UIImage(named: "snow")!
        } else if condition == "cloudy" {
            image = UIImage(named: "cloudy")!
        }
        
        weatherImageView.image = image
    }
    
    func updateCity() {
        cityLabel.text = currentCityName
    }
    
    // MARK: -
    
    func createLocationManager() {
        locationManager.delegate = self
        locationManager.requestLocation()
    }
    
    //MARK: - Buttons Action
    
    @objc func searchButtonPress() {
        let viewController = SearchViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    @objc func mapButtonPress() {
        let viewController = MapViewController()
        navigationController?.pushViewController(viewController, animated: true)
    }
    
    // MARK: -
    
    func getWeatherIn(location: CLLocation?) {
        if let location = location  {
            networkManager.getWeather(latitude: location.coordinate.latitude,
                                      longitude: location.coordinate.longitude) { [weak self] weather, error in
                if let weather = weather {
                    self?.currentWeather = weather
                    self?.updateUI()
                } else {
                    self?.showAlert(text: error?.localizedDescription ?? "произошла ошибка")
                }
            }
        } else {
            showAlert(text: "дай доступ к координатам")
        }
    }
    
    func showAlert(text:String) {
        let alert = UIAlertController(title: "Внимание", message: text, preferredStyle: .alert)
        let alertOk = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(alertOk)
        present(alert, animated: true)
    }
}

