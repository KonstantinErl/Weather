import Foundation
import UIKit

extension SearchViewController {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        resultArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        
        tableCell.textLabel?.text = resultArray[indexPath.row]
        
        return tableCell
    }
}
