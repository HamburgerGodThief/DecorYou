//
//  PhotosCollectionViewCell.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/16.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class PhotosCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var photoImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        photoImg.contentMode = .scaleAspectFill
        numberLabel.layer.cornerRadius = numberLabel.frame.size.width / 2
        numberLabel.layer.borderColor = UIColor.lightGray.cgColor
        numberLabel.layer.borderWidth = 1
        numberLabel.backgroundColor = .clear
        // Initialization code
    }

}
