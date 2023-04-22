import Foundation
import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    let tableView = UITableView()
    
    let arrayOfCityName = ["Тюмень", "Челябинск", "Екатеринбург", "Уфа", "Пермь", "Омск" , "Москва", "Томск"]
    
    var resultArray = [String]()
    
    
    let searchController = UISearchController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        title = "Поиск города"
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
        
        
        view.addSubview(tableView)
        
        setupLayout()
        setupBehaviour()
        
        resultArray = arrayOfCityName
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        searchController.isActive = true
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else {
            return
        }
    }
    
    func setupLayout() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.snp.top).offset(100)
            make.leading.equalTo(view.snp.leading).offset(15)
            make.trailing.equalTo(view.snp.trailing).offset(-15)
            make.bottom.equalTo(view.snp.bottom).offset(-20)
        }
    }
    
    func setupBehaviour() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    
}


/*
 
 добавить карту mkmapview и по нажатию выводились координаты куда нажал
 
 
 
 
 */
