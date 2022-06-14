//
//  ImageCollectionViewCell.swift
//  hw17NatalliaDrozd
//
//  Created by Natalia Drozd on 2.06.22.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var myImageView: UIImageView!
    static let key = "ImageCollectionViewCell"
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override var isSelected: Bool {
        didSet {
            setSelectedAttribute(isSelected: isSelected)
        }
    }
    
    func setSelectedAttribute(isSelected: Bool) {
        self.contentView.backgroundColor = isSelected ? .gray : .white
    }
}
