//
//  CraftsmenCollectionViewCell.swift
//  DecorYou
//
//  Created by Hamburger on 2020/1/31.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class CraftsmenCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var serviceLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    
    func fillInfo(name: String, service: String, location: String) {
        nameLabel.text = name
        serviceLabel.text = service
        locationLabel.text = location
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        logoImg.layer.cornerRadius = logoImg.frame.size.width / 4
        // Initialization code
    }

}
