//
//  CollaboratorCollectionViewCell.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/8.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class CollaboratorCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var logoImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var closeImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        logoImg.layer.cornerRadius = logoImg.frame.size.width / 2
        closeImg.layer.cornerRadius = closeImg.frame.size.width / 2
        closeImg.layer.borderColor = UIColor.white.cgColor
        closeImg.layer.borderWidth = 2
    }

}
