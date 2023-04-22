import Foundation
import UIKit

extension ViewController: UITableViewDataSource, UITableViewDelegate  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let weather = currentWeather else {
            return 0
        }
        
        return weather.days.first?.hours?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: NameTableCell.cellName, for: indexPath) as? NameTableCell else {
            return UITableViewCell()
        }
        
        guard let condition = currentWeather?.days.first?.hours?[indexPath.row] else {
            return UITableViewCell()
        }
        
        cell.setHourse(hourse: condition.datetime)
        cell.setTemperarure(temperature: String(format: "%.1f", condition.temp))
        
        return cell
    }
}
