import Foundation
import CoreLocation
import UIKit
import MapKit

class MapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let mapView = MKMapView()
    let locationManager = CLLocationManager()
    let networkManager = Network()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(mapView)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        mapView.addGestureRecognizer(tapGesture)
        mapView.showsUserLocation = true
        mapView.delegate = self
    
        mapView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading)
            make.trailing.equalTo(view.snp.trailing)
            make.bottom.equalTo(view.snp.bottom)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocation()
    }
    
    @objc func handleTap(gestureReconizer: UITapGestureRecognizer) {
        mapView.removeAnnotations(mapView.annotations)
        
        let location = gestureReconizer.location(in: mapView)
        let coordinate = mapView.convert(location,toCoordinateFrom: mapView)
        
        networkManager.getWeather(latitude: coordinate.latitude,
                                  longitude: coordinate.longitude) { [weak self] weather, error in
            if let weather = weather {
                let annotation = MKPointAnnotation()
                annotation.title = String(format: "%.1f",weather.currentConditions.temp)
                annotation.coordinate = coordinate
                self?.mapView.addAnnotation(annotation) // add annotaion pin on the map
            } else {
                //self?.showAlert(text: error?.localizedDescription ?? "произошла ошибка")
            }
        }
    }
    
    // MARK: -
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation {
            return nil
        }

        let view = MKAnnotationView(frame: CGRect(x: 0, y: 0, width: 30, height: 30))
        view.layer.cornerRadius = 15
        view.backgroundColor = .red
        let label = UILabel()
        view.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.snp.leading).inset(3)
            make.trailing.equalTo(view.snp.trailing).inset(3)
            make.bottom.equalTo(view.snp.bottom)
        }
        
        label.textAlignment = .center
        label.text = annotation.title ?? ""
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .white
        return view
    }
    
    // MARK: -
    
    func checkLocation() {
        if CLLocationManager.locationServicesEnabled() {
            setupManager()
            checkAutorization()
        }else {
            showAlert(title: "Геолокация выключена", message: "Включить геолокацию?", url: URL(string: "App-Prefs:root=LOCATION_SERVICES"))
        }
    }
    
    func setupManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func checkAutorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            locationManager.startUpdatingLocation()
            break
        case .authorizedWhenInUse:
            break
        case .denied:
            showAlert(title: "Вы запретили использование местоположения", message: "Изменить?", url: URL(string: UIApplication.openSettingsURLString))
            break
        case .restricted:
            break
        case .notDetermined:
             locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func showAlert(title: String, message: String?, url:URL?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let settingsActions = UIAlertAction(title: "Настройки", style: .default) {
            (alert) in
            if let url = url {
                UIApplication.shared.open(url)
            }
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        
        alert.addAction(settingsActions)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAutorization()
    }
    
}
