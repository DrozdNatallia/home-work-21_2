//
//  ImageViewCell.swift
//  hw17NatalliaDrozd
//
//  Created by Natalia Drozd on 27.05.22.
//

import UIKit

class ImageViewCell: UITableViewCell {
    
    @IBOutlet weak var myImageView: UIImageView!
    
    @IBOutlet weak var markImageView: UIImageView!
    static let key = "ImageViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        markImageView.isHidden = false
        // картинка со звкздочкой, добавляем, ксли ячейка выбрана
        if isSelected {
            markImageView.isHidden = false
        } else {
            markImageView.isHidden = true
        }
        
    }
}
