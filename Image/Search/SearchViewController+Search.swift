import Foundation
import UIKit

extension SearchViewController {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        resultArray.removeAll()
        
        for city in arrayOfCityName {
            if city.hasPrefix(searchText) {
                resultArray.append(city)
            }
        }
        tableView.reloadData()
    }
}
