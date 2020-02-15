//
//  ServiceAreaCollectionViewCell.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/14.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class ServiceAreaCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var areaLabel: UILabel!
    var select: Bool = false
    
    override func layoutSubviews() {
        super.layoutSubviews()
        areaLabel.layer.cornerRadius = areaLabel.frame.size.height / 2
        areaLabel.layer.borderColor = UIColor.assetColor(.shadowLightGray)?.cgColor
        areaLabel.layer.borderWidth = 1
        areaLabel.clipsToBounds = true
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
    }

}
