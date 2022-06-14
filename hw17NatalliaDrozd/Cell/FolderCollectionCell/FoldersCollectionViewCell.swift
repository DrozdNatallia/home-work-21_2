//
//  FoldersCollectionViewCell.swift
//  hw17NatalliaDrozd
//
//  Created by Natalia Drozd on 2.06.22.
//

import UIKit

class FoldersCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var myLabel: UILabel!
    static let key = "FoldersCollectionViewCell"
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
