//
//  UnboxCollectionViewCell.swift
//  DecorYou
//
//  Created by Hamburger on 2020/2/29.
//  Copyright © 2020 Hamburger. All rights reserved.
//

import UIKit

class UnboxCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var unboxView: UIView!
    @IBOutlet weak var unboxImg: UIImageView!
    @IBOutlet weak var cancelImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        unboxView.layer.borderColor = UIColor.lightGray.cgColor
        unboxView.layer.borderWidth = 2
    }

}
