//
//  CollaboratorLogoCollectionViewCell.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/9.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class CollaboratorLogoCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var logoImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        logoImg.layer.cornerRadius = self.bounds.height / 2
    }

}
