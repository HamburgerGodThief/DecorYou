//
//  FilterCollectionViewCell.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/20.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class FilterCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var optionLabel: UILabel!
    var select: Bool = false {
        willSet {
            if newValue == true
            {
                self.layer.borderWidth = 1.0
                self.layer.borderColor = UIColor.assetColor(.mainColor)?.cgColor
                self.backgroundColor = .white
            }
            else
            {
                self.layer.borderWidth = 0.0
                self.backgroundColor = UIColor.assetColor(.shadowLightGray)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
