import Foundation
import UIKit

class NameTableCell: UITableViewCell {
    
    static let cellName = "CellName"
    
    let nameLabel1 = UILabel()
    let nameLabel2 = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(nameLabel1)
        contentView.addSubview(nameLabel2)
        
        setupLayoutLabel()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLayoutLabel () {
        nameLabel1.snp.makeConstraints { make in
            make.width.equalTo(150)
            make.top.equalTo(contentView.snp.top).offset(16)
            make.leading.equalTo(contentView.snp.leading).offset(16)
            make.bottom.equalTo(contentView.snp.bottom).offset(-16)
        }
        
        nameLabel2.snp.makeConstraints { make in
            make.top.equalTo(contentView.snp.top).offset(16)
            make.leading.equalTo(nameLabel1.snp.trailing).offset(10)
            make.trailing.equalTo(contentView.snp.trailing).offset(-16)
            make.bottom.equalTo(contentView.snp.bottom).offset(-16)
        }
    }
    
    func setHourse(hourse: String) {
        nameLabel1.text = ("Время: \(hourse)")
    }
    
    func setTemperarure(temperature: String) {
        nameLabel2.text = ("Температура: \(temperature)")
    }
}

