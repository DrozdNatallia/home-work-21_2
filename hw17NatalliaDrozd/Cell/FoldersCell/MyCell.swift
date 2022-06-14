//
//  MyCell.swift
//  hw17NatalliaDrozd
//
//  Created by Natalia Drozd on 25.05.22.
//

import UIKit
import SnapKit

class MyCell: UITableViewCell {
    // лэйбл для названия папки

    @IBOutlet weak var myImageView: UIImageView!
    var label: UILabel!
    // ключ
    static let key = "MyCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // извлекаем опционал
        guard imageView != nil, let imageView = imageView else {
            return
        }
        // добавляем лэйбл и констрейнты
        label = UILabel()
        contentView.addSubview(label)
        label.snp.makeConstraints { make in
            make.leading.equalTo(imageView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(16)
            make.top.equalToSuperview().inset(16)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        myImageView.isHidden = false
        // картинка со звкздочкой, добавляем, ксли ячейка с папкой выбрана
        if isSelected {
            myImageView.isHidden = false
        } else {
            myImageView.isHidden = true
        }
    }
    
}
