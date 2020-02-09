//
//  CollaboratorTableViewCell.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/8.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class CollaboratorTableViewCell: UITableViewCell {

    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var selectedIcon: UIImageView!
    var select = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        logoImg.layer.cornerRadius = logoImg.frame.size.width / 2
        logoImg.backgroundColor = UIColor.assetColor(.mainColor)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
